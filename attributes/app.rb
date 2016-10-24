# Set where to install / extract the sesshu.
default['sesshu']['home'] = '/opt/sesshu'
default['sesshu']['user'] = 'sesshu'

# Set the source git URL.
default['sesshu']['git']['path'] = 'https://github.com/darkarnium/sesshu.git'
default['sesshu']['git']['branch'] = 'develop'

# Set the input and output ARNs / URLs.
default['sesshu']['conf']['bus']['input']['queue'] = 'X'
default['sesshu']['conf']['bus']['output']['arn'] = 'Y'

# Set the log path.
default['sesshu']['conf']['logging']['path'] = "#{node['sesshu']['home']}/logs/"
