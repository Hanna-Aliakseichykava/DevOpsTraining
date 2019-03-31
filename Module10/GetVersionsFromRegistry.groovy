import groovy.json.JsonSlurper

def json = 'curl -X GET http://localhost:5000/v2/task7/tags/list'.execute().text

def jsonSlurper = new JsonSlurper()
def object = jsonSlurper.parseText(json)

return object.tags