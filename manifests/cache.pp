# @summary patch cache support
#
# @api private
#
# @param directory
#   where to store patch files
# @param mode
#   file mode for directory
# @param owner
#   directory and patch file owner
# @param group
#   directory and patch file group
class patch::cache (
  Stdlib::Absolutepath $directory,
  String $mode,
  String $owner,
  String $group,
) {
  file { $directory:
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }
}
