# Redmine - project management software
# Copyright (C) 2006-2008  Shereef Bishay
#

require File.dirname(__FILE__) + '/../../../test_helper'

class Redmine::PluginTest < ActiveSupport::TestCase

  def setup
    @klass = Redmine::Plugin
    # In case some real plugins are installed
    @klass.clear
  end
  
  def teardown
    @klass.clear
  end
  
  def test_register
    @klass.register :foo do
      name 'Foo plugin'
      url 'http://example.net/plugins/foo'
      author 'John Smith'
      author_url 'http://example.net/jsmith'
      description 'This is a test plugin'
      version '0.0.1'
      settings :default => {'sample_setting' => 'value', 'foo'=>'bar'}, :partial => 'foo/settings'
    end
    
    assert_equal 1, @klass.all.size
    
    plugin = @klass.find('foo')
    assert plugin.is_a?(Redmine::Plugin)
    assert_equal :foo, plugin.id
    assert_equal 'Foo plugin', plugin.name
    assert_equal 'http://example.net/plugins/foo', plugin.url
    assert_equal 'John Smith', plugin.author
    assert_equal 'http://example.net/jsmith', plugin.author_url
    assert_equal 'This is a test plugin', plugin.description
    assert_equal '0.0.1', plugin.version
  end
  
  def test_requires_redmine
    test = self
    version = Redmine::VERSION.to_a.slice(0,3).join('.')
    
    @klass.register :foo do
      test.assert requires_redmine(:version_or_higher => '0.1.0')
      test.assert requires_redmine(:version_or_higher => version)
      test.assert requires_redmine(version)
      test.assert_raise Redmine::PluginRequirementError do
        requires_redmine(:version_or_higher => '99.0.0')
      end
      
      test.assert requires_redmine(:version => version)
      test.assert requires_redmine(:version => [version, '99.0.0'])
      test.assert_raise Redmine::PluginRequirementError do
        requires_redmine(:version => '99.0.0')
      end
      test.assert_raise Redmine::PluginRequirementError do
        requires_redmine(:version => ['98.0.0', '99.0.0'])
      end
    end
  end
end
