# @summary manage required packages
#
# @api private
#
# @param patch
#   package containing the patch command
# @param manage
#   manage package resources
#
class patch::package (
  String  $patch,
  String  $git,
  Boolean $manage,
) {
  if $manage {
    if !defined(Package[$patch]) {
      package { $patch: }
    }
  }
}
