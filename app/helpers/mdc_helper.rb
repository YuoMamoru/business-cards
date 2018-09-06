# frozen_string_literal: true

module MdcHelper
  SUPPORT_VERSION = "0.39.1"

  # Create javascript include tag for {Material Components for the Web}[https://material.io/components/web/].
  def mdc_javascript_include_tag
    raw(%(<script src="https://unpkg.com/material-components-web@#{SUPPORT_VERSION}/dist/material-components-web.js"></script>))
  end
end
