# # encoding: utf-8

# Inspec test for recipe scrapyd-deploy::python

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

global_python = '3.6.5'

describe bash('source /etc/profile.d/pyenv.sh && pyenv global') do
  its('exit_status') { should eq(0) }
  its('stdout') { should match(global_python) }
  its('stdout') { should_not match('system') }
end

describe bash('source /etc/profile.d/pyenv.sh && python -V') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(global_python) }
end

describe bash('source /etc/profile.d/pyenv.sh && pip -V') do
  its('exit_status') { should eq 0 }
end
