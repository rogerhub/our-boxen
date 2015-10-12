class people::rogerhub {

  $home = "/Users/${::boxen_user}"

  include chrome
  include spotify
  include brewcask
  include dropbox
  include java
  include vagrant
  include python
  include adobe_reader
  include adobe_creative_cloud
  include seil
  include seil::login_item

  vagrant::plugin { "vmware-fusion": }

  seil::bind { 'keyboard bindings':
    mappings => { 'capslock' => 53 }
  }

  class {
    'fish':
      chsh => false;
    # 'virtualbox':
    #   version => '4.3.30',
    #   patch_level => '101610';
  }

  homebrew::tap {
    "homebrew/x11":
      ;
    "homebrew/fuse":
      ;
  }
  ->
  package {
    [
      'rdiff-backup',
      'awscli',
      'fswatch',
      'go',
      'ctags',
      'the_silver_searcher',
      'rdesktop',
      'ant',
      'maven',
      'wget',
      'pstree',
      'duplicity',
      'mcrypt',
      'groovysdk',
      'iperf',
      'mtr',
      'unrar',
      'htop-osx',
      'wakeonlan',
      'vim',
      'tmux',
      'scala',
      'macvim',
      'openssl',
      'imagemagick',
      'gcc',
      'fuse-zip',
    ]:
      ensure => installed,
      provider => 'homebrew';
    [
      "sshfs",
      'keepassx',
      'gnucash',
      'google-hangouts',
      'vlc',
      'xquartz',
      'calibre',
      'caffeine',
      'nmap',
      'osxfuse',
      'tunnelblick',
      'eclipse-java',
      'chefdk',
      'google-drive',
      'mactex',
      'bettertouchtool',
    ]:
      ensure => installed,
      provider => 'brewcask';
  }

  Package[osxfuse] -> Package[sshfs] -> Package[fuse-zip]

  ruby_gem {
    'tugboat for 2.0.0':
      ensure => present,
      gem => 'tugboat',
      ruby_version => '2.0.0';
    'sass for 2.0.0':
      ensure => present,
      gem => 'sass',
      ruby_version => '2.0.0';
    'uglifier for 2.0.0':
      ensure => present,
      gem => 'uglifier',
      ruby_version => '2.0.0';
    'sqlite3 for 2.0.0':
      ensure => present,
      gem => 'sqlite3',
      ruby_version => '2.0.0';
    'puppet-lint for 2.0.0':
      ensure => present,
      gem => 'puppet-lint',
      ruby_version => '2.0.0';
    'nokogiri for 2.0.0':
      ensure => present,
      gem => 'nokogiri',
      ruby_version => '2.0.0';
  }

  python::pip {
    [
      'ipython',
      'line-profiler',
      'psutil',
      'ipdb',
      'pycosat',
      'pudb',
      'virtualenv',
      'pyzmq',
      'jinja2',
      'tornado',
      'numpy',
      'scipy',
      'matplotlib',
      'boto',
      'dropbox',
      'requests',
      'scikit-learn',
      'scikit-image',
      'gdata',
      'Pillow',
      'cython',
    ]:
      # screw your rules
      virtualenv => '/opt/boxen/homebrew/',
      ensure => present;
  }

  Package[gcc] -> Python::Pip[scipy, scikit-image]


  include osx::no_network_dsstores
  include osx::finder::unhide_library
  include osx::global::expand_save_dialog
  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access
  include osx::global::disable_autocorrect

  include osx::software_update

  class {
    'osx::global::key_repeat_rate':
      rate => 2;
    'osx::global::key_repeat_delay':
      delay => 15;
    'osx::dock::position':
      position => 'bottom';
    'osx::dock::icon_size':
      size => 48;
    'osx::global::tap_to_click':;
  }

  Boxen::Osx_defaults {
    user => $::boxen_user,
  }

  boxen::osx_defaults {
    'Enable Three Finger Drag':
      domain => 'com.apple.driver.AppleBluetoothMultitouch.trackpad',
      key => 'TrackpadThreeFingerDrag',
      value => 1,
      type => 'integer';
  }

  git::config::global {
    'user.name':
      value => 'Roger Chen';
    'user.email':
      value => 'roger@rogerhub.com';
    'push.default':
      value => 'simple';
    'alias.au':
      value => 'add -u';
    'alias.lg':
      value => "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Cre    set %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit";
    'alias.dc':
      value => 'diff --cached';
    'alias.dm':
      value => "\"!/bin/bash -c 'git diff $(git merge-base HEAD master) --' __dummy__\"";
    'alias.lf':
      value => 'ls-files';
    'alias.li':
      value => 'ls-files -o -i --exclude-standard';
    'alias.st':
      value => 'status';
    'alias.ci':
      value => 'commit';
    'alias.co':
      value => 'checkout';
    'alias.ss':
      value => 'show --name-status';
    'alias.ds':
      value => 'diff --name-status';
    'alias.subdate':
      value => 'submodule foreach git pull';
    'alias.up':
      value => "!sh -c 'git pull --prune && git submodule update --init --recursive'";
    'alias.unstage':
      value => 'reset HEAD';
    'color.ui':
      value => true;
    'core.editor':
      value => 'vim';
    'core.pager':
      value => 'less -+X -+F';
  }

  repository {
    "${home}/.vim-config":
      source => 'rogerhub/vim-config';
  }

  exec { "fuck_puppet":
    command => "/bin/test -e ${home}/Configuration/ssh",
  }
  ->
  file {
    "${home}/.ssh":
      force => true,
      ensure => "${home}/Configuration/ssh";
  }

  file {
    "${home}/Configuration":
      ensure => "${home}/Development/Configuration";
    "${home}/.vim":
      ensure => "${home}/.vim-config/.vim";
    "${home}/.vimrc":
      ensure => "${home}/.vim-config/.vimrc";
    "${home}/.gvimrc":
      ensure => "${home}/.vim-config/.gvimrc";
    "${home}/.zshconfig":
      ensure => "${home}/Configuration/zshconfig";
    "${home}/.config/fish/config.fish":
      ensure  => "${home}/Configuration/config.fish",
      require => Package[fish];
    "${home}/Local":
      ensure => directory;
    "${home}/.bcrc":
      ensure => "${home}/Configuration/bcrc";
    "${home}/.aws":
      ensure => directory,
      mode => '0700';
    "${home}/.tugboat":
      mode => '0600';
    "${home}/.megacmd.json":
      mode => '0600';
    "${home}/.ipython":
      ensure => "${home}/Configuration/ipython";
    "${home}/.tmux.conf":
      ensure => "${home}/Configuration/tmux.conf";
    '/opt/boxen/repo/bin/gvim':
      ensure => symlink,
      target => '/usr/bin/vim'; # Stub to help fish autocompletion (overridden by fish config)
  }

  class { 'nginx':
    ensure => absent;
  }
}
