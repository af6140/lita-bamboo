require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "bamboohelper/plans"
require "lita/handlers/bamboo"
require "lita"

Lita::Handlers::Bamboo.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
