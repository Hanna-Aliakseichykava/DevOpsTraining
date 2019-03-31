tags = []
text = "sudo knife client list -c /root/chef-repo/.chef/knife.rb".execute().text
text.eachLine { tags.push(it) }
return tags