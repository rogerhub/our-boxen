class people::rogerhub {
  include chrome
  include spotify
  include brewcask
  include dropbox

  class { 'fish':
    chsh => true;
  }

  package {
    ['rdiff-backup', 'awscli', 'fswatch']:
      ensure => installed,
      provider => 'homebrew';
    ['gpgtools', 'macvim', 'keepassx', 'gnucash', 'google-hangouts', 'vlc', 'inkscape', 'xquartz', 'calibre']:
      ensure => installed,
      provider => 'brewcask';
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
    'osx::dock::icon_size':
      size => 36;
  }

  $home = "/Users/${::boxen_user}"

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
    'alias.st':
      value => 'status';
    'alias.co':
      value => 'checkout';
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
    "${home}/.aws":
      ensure => directory,
      mode => 700;
    "${home}/.tugboat":
      mode => 600;
  }

  file {
    "/usr/bin/fish":
      ensure => "/opt/boxen/homebrew/bin/fish",
      owner => root,
      group => wheel;
  }
}
