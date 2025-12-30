project('novabar', 'vala', 'c',
  version: '0.1.0',
  meson_version: '>= 0.50.0',
)

add_project_arguments(['-D', 'WNCK_I_KNOW_THIS_IS_UNSTABLE'], language: 'c')

dependencies = [
  dependency('gtk+-3.0'),
  dependency('glib-2.0'),
  dependency('gio-2.0'),
  dependency('gdk-x11-3.0'),
  dependency('libwnck-3.0'),
  dependency('x11'),
  dependency('libnm'),
]

sources = files(
  # Main
  'src/main.vala',
  'src/panel.vala',
  
  # Global Menu
  'src/globalmenu/menubar.vala',
  
  # Logo Menu
  'src/logomenu/logomenu.vala',
  
  # Indicators
  'src/indicators/datetime/datetime.vala',
  'src/indicators/sound/sound.vala',
  'src/indicators/network/network.vala',
  'src/indicators/bluetooth/bluetooth.vala',
  'src/indicators/battery/battery.vala',
  'src/indicators/notifications/notifications.vala',
  'src/indicators/controlcenter/controlcenter.vala',
  'src/about/about.vala',
  'src/settings/settings.vala',
)

executable('novabar',
  sources,
  dependencies: dependencies,
  install: true,
)

install_data('data/novaos.css',
  install_dir: get_option('datadir') / 'novaos'
)

install_data('data/novaos-light.css',
  install_dir: get_option('datadir') / 'novaos'
)
