switch (PLATFORM_NAME) {
  case 'development':
    properties([
      parameters([
        string(defaultValue: 'master', description: 'GIT branch name you would like to pull infrastructure code from', name: 'INFRA_GIT_BRANCH', trim: false),
        validatingString(defaultValue: '', description: 'Environment name to tag resources with', failedValidationMessage: 'Minimum 3 chars, maximum 10 chars, alphanumeric, lowercase, and hyphen only.', name: 'ENVIRONMENT_NAME', regex: '[0-9a-z\\-]{3,10}'),
        choice(choices: ['ee-shop', 'ee-platform-services', 'ee-architecture', 'ee-marketing', 'ee-operations', 'ee-qa', 'ee-self-serve', 'bt-aem', 'bt-help'], description: 'For billing purposes', name: 'OWNER'),
        string(defaultValue: 'master', description: 'GIT branch name you would like to pull Istio gateway infrastructure code from', name: 'ISTIO_GATEWAY_INFRA_GIT_BRANCH', trim: false),
        validatingString(defaultValue: '', description: 'Tag (version) of Istio gateway to deploy', failedValidationMessage: 'Minimum 3 chars, alphanumeric, lowercase, dots and hyphen only.', name: 'SHOP_ISTIO_GATEWAY_TAG', regex: '[0-9a-z.\\-]{3,}'),
        string(defaultValue: 'master', description: 'GIT branch name you would like to pull SPA infrastructure code from', name: 'SPA_INFRA_GIT_BRANCH', trim: false),
        validatingString(defaultValue: '', description: 'Tag (version) of SPA to deploy', failedValidationMessage: 'Minimum 3 chars, alphanumeric, lowercase, dots and hyphen only.', name: 'SHOP_SPA_TAG', regex: '[0-9a-z.\\-]{3,}'),
        validatingString(defaultValue: '', description: 'Enabling SPA feature toggles, example: pdp, eocn', failedValidationMessage: 'Expects alphabetic characters and commas.', name: 'SPA_FEATURE_TOGGLES', regex: '[a-zA-Z,\\s]+|'),
        string(defaultValue: 'master', description: 'GIT branch name you would like to pull Facade infrastructure code from', name: 'FACADE_INFRA_GIT_BRANCH', trim: false),
        validatingString(defaultValue: '', description: 'Tag (version) of Facade to deploy', failedValidationMessage: 'Minimum 3 chars, alphanumeric, lowercase, dots and hyphen only.', name: 'SHOP_FACADE_TAG', regex: '[0-9a-z.\\-]{3,}'),
        string(defaultValue: 'latest', description: 'Choose RDS snapshot for Hybris DB', name: 'HYBRIS_RDS_SNAPSHOT', trim: false),
        booleanParam(defaultValue: true, description: 'Whether to use trimmed RDS snapshot', name: 'TRIMMED_SNAPSHOT'),
        choice(choices: ['release', 'master', 'develop', 'RC/coming_train', 'RC/second_train', 'custom'], description: 'Git branch name you would like to pull shop artifacts from', name: 'SHOP_ARTIFACT_BRANCH'),
        validatingString(defaultValue: 'latest', description: 'Shop artifact build ID from CI Jenkins you would like to use for this deployment', failedValidationMessage: 'Minimum 1 char, Maximum 12 chars, alphanumeric, lowercase, and hyphen only.', name: 'SHOP_ARTIFACT_BUILD_ID', regex: '[0-9a-z\\-]{1,12}'),
        validatingString(defaultValue: '', description: '!!!DEPRECATED!!! Tag (version) of NEW stubs artifact to deploy', failedValidationMessage: 'Minimum 3 chars, alphanumeric, lowercase, dots and hyphen only.', name: 'STUBS_TAG', regex: '[0-9a-z.\\-]'),
        validatingString(defaultValue: 'false', description: 'Type system to use in the Hybris database', failedValidationMessage: 'Minimum 4 chars, alphanumeric, lowercase, and hyphen only.', name: 'TYPE_SYSTEM', regex: '[0-9a-z\\-]{4,}'),
        booleanParam(defaultValue: true, description: 'Run the ant job to update the type system', name: 'RUN_SYSTEM_UPDATE'),
        string(defaultValue: 'hybris/bin/custom/ee/eecore/resources/eecore/import/release/system-update-configuration.json', description: 'Path to update config json on the admin node', name: 'SYSTEM_UPDATE_CONFIG_PATH', trim: false),
        string(defaultValue: 'false', description: 'Custom AEM endpoint for Hybris', name: 'AEM_CUSTOM_BACKEND', trim: false),
        booleanParam(defaultValue: false, description: 'Set up the environment with Redshift enabled', name: 'ENABLE_REDSHIFT'),
        booleanParam(defaultValue: false, description: 'Set up the environment with Dynatrace enabled', name: 'ENABLE_DYNATRACE')
      ])
    ])
    BACKEND_TYPE = 'stubs'
    OIDC_CLIENTID = 'false'
    OIDC_SECRET = 'false'
    UPGRADE_CLIENTID = 'false'
    ENABLE_DELAYS = 'false'
    START_DELAY = '0'
    break;
