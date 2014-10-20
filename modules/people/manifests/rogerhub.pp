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

  class {
    'fish':
      chsh => true;
    'virtualbox':
      version => '4.3.18',
      patch_level => '96516';
  }

  package {
    ['rdiff-backup', 'awscli', 'fswatch', 'go', 'ctags', 'the_silver_searcher', 'rdesktop']:
      ensure => installed,
      provider => 'homebrew';
    ['gpgtools', 'macvim', 'keepassx', 'gnucash', 'google-hangouts', 'vlc', 'inkscape', 'xquartz', 'calibre', 'basictex', 'texshop', 'caffeine', 'nmap']:
      ensure => installed,
      provider => 'brewcask';
  }

  include nodejs::v0_10

  class { 'nodejs::global':
    version => 'v0.10.26';
  }

  nodejs::module { 'localtunnel':
    node_version => 'v0.10';
  }

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
  }

  python::pip {
    ['ipython', 'line-profiler', 'psutil', 'ipdb', 'pycosat']:
      # screw your rules
      virtualenv => '/opt/boxen/homebrew/',
      ensure => present;
  }


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
    'osx::dock::hot_corners':
      bottom_left => "Put Display to Sleep";
    'osx::dock::position':
      position => 'bottom';
    'osx::dock::icon_size':
      size => 48;
  }

  git::config::global {
    'user.name':
      value => 'Roger Chen';
    'user.email':
      value => 'roger@rogerhub.com';
    'push.default':
      value => 'simple';
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
      value => 'true';
  }

  repository {
    "${home}/.vim-config":
      source => 'rogerhub/vim-config';
    "${home}/.oh-my-zsh":
      source => 'robbyrussell/oh-my-zsh';
  }

  file {
    "${home}/.vim":
      ensure => "${home}/.vim-config/.vim";
    "${home}/.vimrc":
      ensure => "${home}/.vim-config/.vimrc";
    "${home}/.gvimrc":
      ensure => "${home}/.vim-config/.gvimrc";
    "${home}/.ssh":
      force => true,
      ensure => "${home}/Configuration/ssh";
    "${home}/.zshconfig":
      ensure => "${home}/Configuration/zshconfig";
    "${home}/.config/fish/config.fish":
      ensure => "${home}/Configuration/config.fish";
    "${home}/Local":
      ensure => directory;
    "${home}/.bcrc":
      ensure => "${home}/Configuration/bcrc";
    "${home}/.scrc":
      ensure => "${home}/Configuration/scrc";
    "${home}/.aws":
      ensure => directory,
      mode => 700;
    "${home}/.tugboat":
      mode => 600;
    "${home}/.megacmd.json":
      mode => 600;
    "${home}/.ipython":
      ensure => "${home}/Configuration/ipython";
    "/opt/boxen/repo/bin/gvim":
      ensure => '/usr/bin/vim'; /* Stub to help fish autocompletion (overridden by fish config) */
  }

  file {
    "/usr/bin/fish":
      ensure => "/opt/boxen/homebrew/bin/fish",
      owner => root,
      group => wheel;
  }

  class { 'nginx':
    ensure => absent;
  }
}
