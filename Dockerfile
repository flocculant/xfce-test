FROM ubuntu:17.04
MAINTAINER Florian Schüller <florian.schueller@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY ${DISPLAY:-:1}

# Test specific
# python-wheel is a missing dependency from behave
# psmisc for "killall"
RUN apt-get update \
 && apt-get -y --no-install-recommends install apt-utils psmisc \
 && apt-get -y install dirmngr git python-ldtp ldtp python-pip python-wheel python-dogtail python-psutil

RUN /usr/bin/pip install --upgrade pip
RUN /usr/bin/pip install behave

COPY xubuntu-dev-xfce4-gtk3-zesty.list /etc/apt/sources.list.d/
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB563F93142986CE

#XFCE specific
RUN apt-get update \
 && apt-get -y install gnome-themes-standard libglib2.0-bin build-essential libgtk-3-dev gtk-doc-tools libgtk2.0-dev libx11-dev libglib2.0-dev libwnck-3-dev intltool libdbus-glib-1-dev liburi-perl x11-xserver-utils libvte-2.91-dev dbus-x11 strace libgl1-mesa-dev adwaita-icon-theme libwnck-dev adwaita-icon-theme-full cmake libsoup2.4-dev \
 && rm -rf /var/lib/apt/lists/*

#needed for LDTP and friends
RUN /usr/bin/dbus-run-session /usr/bin/gsettings set org.gnome.desktop.interface toolkit-accessibility true

# create the directory for version_info.txt
RUN useradd -ms /bin/bash test_user

# group all repos here
RUN mkdir /git

# rather use my patched version
RUN cd git \
 && git clone https://github.com/schuellerf/ldtp2.git \
 && cd ldtp2 \
 && python setup.py install

# line used to invalidate all git clones
ARG DOWNLOAD_DATE=give_me_a_date
ARG AUTOGEN_OPTIONS="--disable-debug --enable-maintainer-mode --host=x86_64-linux-gnu \
                    --build=x86_64-linux-gnu --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu \
                    --libexecdir=/usr/lib/x86_64-linux-gnu --sysconfdir=/etc --localstatedir=/var --enable-gtk3 --enable-gtk-doc"

# Grab xfce4-dev-tools from master
RUN cd git \
  && git clone git://git.xfce.org/xfce/xfce4-dev-tools \
  && cd xfce4-dev-tools \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt \
  && ldconfig

# Grab libxfce4util from master
RUN cd git \
  && git clone git://git.xfce.org/xfce/libxfce4util \
  && cd libxfce4util \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt \
  && ldconfig

# Grab xfconf from master
RUN cd git \
  && git clone git://git.xfce.org/xfce/xfconf \
  && cd xfconf \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt \
  && ldconfig

# Grab libxfce4ui from master
RUN cd git \
  && git clone git://git.xfce.org/xfce/libxfce4ui \
  && cd libxfce4ui \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt \
  && ldconfig

# Grab garcon from master
RUN cd git \
  && git clone git://git.xfce.org/xfce/garcon \
  && cd garcon \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt \
  && ldconfig

# Grab exo from master
RUN cd git \
  && git clone git://git.xfce.org/xfce/exo \
  && cd exo \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt \
  && ldconfig

# Grab xfce4-panel
RUN cd git \
  && git clone git://git.xfce.org/xfce/xfce4-panel \
  && cd xfce4-panel \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt

# Grab thunar
RUN cd git \
  && git clone git://git.xfce.org/xfce/thunar \
  && cd thunar \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt

# Grab xfce4-settings
RUN cd git \
  && git clone git://git.xfce.org/xfce/xfce4-settings \
  && cd xfce4-settings \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt


# Grab xfce4-session
RUN cd git \
  && git clone git://git.xfce.org/xfce/xfce4-session \
  && cd xfce4-session \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt

# Grab xfdesktop
RUN cd git \
  && git clone git://git.xfce.org/xfce/xfdesktop \
  && cd xfdesktop \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt

# Grab xfwm4
RUN cd git \
  && git clone git://git.xfce.org/xfce/xfwm4 \
  && cd xfwm4 \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt

# Grab xfce4-appfinder
RUN cd git \
  && git clone git://git.xfce.org/xfce/xfce4-appfinder \
  && cd xfce4-appfinder \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt

# Grab tumbler
RUN cd git \
  && git clone git://git.xfce.org/xfce/tumbler \
  && cd tumbler \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt

# Grab xfce4-terminal
RUN cd git \
  && git clone git://git.xfce.org/apps/xfce4-terminal \
  && cd xfce4-terminal \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt

# Grab xfce4-whiskermenu-plugin
RUN cd git \
  && git clone git://git.xfce.org/panel-plugins/xfce4-whiskermenu-plugin \
  && cd xfce4-whiskermenu-plugin \
  && mkdir build && cd build \
  && cmake -DCMAKE_INSTALL_PREFIX=/usr .. \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt

# Grab xfce4-clipman
RUN cd git \
  && git clone git://git.xfce.org/panel-plugins/xfce4-clipman-plugin \
  && cd xfce4-clipman-plugin \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt

# Grab xfce4-screenshooter
RUN cd git \
  && git clone git://git.xfce.org/apps/xfce4-screenshooter \
  && cd xfce4-screenshooter \
  && ./autogen.sh $AUTOGEN_OPTIONS \
  && make \
  && make install \
  && echo "$(pwd): $(git describe)" >> ~test_user/version_info.txt

USER test_user
ENV HOME /home/test_user

RUN echo 'if [[ $- =~ "i" ]]; then echo -n "This container includes:\n"; cat ~test_user/version_info.txt; fi' >> ~test_user/.bashrc

COPY behave /behave_tests

CMD [ "/bin/bash", "-c", "xfce4-session" ]
