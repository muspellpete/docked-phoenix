FROM manjarolinux/base

# Fix for bug with glibc
RUN curl -fsSL "https://repo.archlinuxcn.org/x86_64/glibc-linux4-2.33-4-x86_64.pkg.tar.zst" | bsdtar -C / -xvf -

# Update everything
RUN pacman -Syyu --noconfirm

# Do everything else inside /elixir folder
RUN mkdir /elixir
WORKDIR /elixir

# Install Elixir and Phoenix
RUN pacman -S elixir --noconfirm
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new 1.5.8 --force

# Set up tools
RUN pacman -S --noconfirm vim inotify-tools npm nodejs python2
RUN pacman -S base-devel <<< '' --noconfirm

# Make test app and host
RUN mix phx.new amazing --install
RUN cd amazing

# Set up test environment in /testing folder
WORKDIR /testing
COPY ./Testing .

# Fix postgres host name
WORKDIR /elixir
RUN sed -i 's/  hostname: "localhost",/  hostname: "postgres",/' amazing/config/dev.exs

# Loop to keep awake after moving to the amazing project folder
WORKDIR /elixir/amazing
CMD mix ecto.create && tail -f /dev/null
# then run mix phx.server inside the container