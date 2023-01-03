# @summary patch defined type defaults and system setup
#
# @param loose
#   match patterns loosely, in case tabs or spaces have been munged in your files
# @param backup
#   create backups of successfully patched files
#
# @api private
#
class patch::default (
  Boolean $backup,
  Boolean $loose,
) {
  contain patch::package
  contain patch::cache
}
