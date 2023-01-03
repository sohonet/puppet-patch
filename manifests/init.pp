# @summary Apply patch to a target path
#
# @param target
#   directory where the patch will be applied
# @param content
#   text of a unified diff
# @param source
#   unified diff file
# @param strip
#   strip the smallest prefix containing num leading slashes from each file name in the patch file
# @param loose
#   match patterns loosely, in case tabs or spaces have been munged in your files
# @param backup
#   create backups of successfully patched files
#
# @example
#   patch { 'patch vendor templates':
#     target => '/opt/application/templates',
#     source => file("${module_name}/vendor.patch"),
#     strip  => 1,
#   }
define patch (
  Stdlib::Absolutepath $target  = $title,
  Optional[String]     $content = undef,
  Optional[String]     $source  = undef,
  Integer              $strip   = 0,
  Optional[Boolean]    $loose   = undef,
  Optional[Boolean]    $backup  = undef,
) {
  require patch::default

  if ($content =~ Undef and $source =~ Undef) {
    fail('content or source required')
  }

  $patch_file = sprintf('%s/%s.patch',
    $patch::cache::directory,
    regsubst(regsubst($title, /\s/, '-', 'G'), /[^\w_-]/, '', 'G'),
  )

  $_loose = ($loose =~ Undef) ? {
    true  => $patch::default::loose,
    false => $loose,
  }
  $_backup = ($backup =~ Undef) ? {
    true  => $patch::default::backup,
    false => $backup,
  }

  $backup_option = $_backup ? {
    true  => '',
    false => '-V never -r -',
  }
  $loose_option = $_loose ? {
    true  => '--ignore-whitespace',
    false => '',
  }

  file { "${title}.patch":
    ensure       => file,
    path         => $patch_file,
    content      => $content,
    source       => $source,
    owner        => $patch::cache::owner,
    group        => $patch::cache::group,
    mode         => $patch::cache::mode,
    validate_cmd => sprintf('/usr/bin/env patch --dry-run %s %s --forward --strip %s < %%', $loose_option, $backup_option, $strip),
  }

  -> exec { "${title}.patch":
    command => sprintf('/usr/bin/env patch %s %s --forward --strip %d < %s', $loose_option, $backup_option, $strip, $patch_file),
    unless  => sprintf('/usr/bin/env patch %s --reverse --dry-run --strip %d < %s', $loose_option, $strip, $patch_file),
    cwd     => $target,
  }
}
