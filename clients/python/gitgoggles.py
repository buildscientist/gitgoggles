'''
Created on Jun 3, 2012
@author: yelkalay
@summary: A Pythonic class based interface to the GitGoggles REST service. 
'''
import string
import requests

class GitGoggles(object):
    '''
    Pythonic interface to GitGoggles REST service via urllib2. GitGoggles returns responses in JSON.
    Since we're interested in using Python data structures all JSON responses are converted to Python dictionaries.
    Each of the helper methods below uses an existing requests handle/thread to do an HTTP GET on a GitGoggles
    resource. The requests module detects response headers with a application/json content type and converts 
    the JSON into a Python dictionary.  
    '''
    
    def __init__(self,service_url):
        
        self.service_url = service_url
        self.repositories_uri = '/repositories'
        self.repository_uri = '/repository'
        self.commits_uri = '/commits'
        self.commit_uri = '/commit'
        self.tags_uri = '/tags'
        self.tag_uri = '/tag'
        self.branch_uri = '/branch'
        self.branches_uri = '/branches'
        self.request = None
        
        self.get_service_root()
        
    def get_service_root(self):
        '''Open a connection to the root of the service to verify it's a valid URL. '''
        try:
            requests.get(self.service_url)
        
        except requests.exceptions.ConnectionError, error:
            error = "Invalid URL (%s) or connection timeout. Check Service URL" %(self.service_url)
            raise RuntimeError(error)
             
    'GET /repositories'        
    def get_all_repositories(self):
        url = string.join([self.service_url,self.repositories_uri],'/')
        return requests.get(url).json
    
    'GET /repository'
    def get_repository_tree(self,repository):
        url = string.join([self.service_url,self.repository_uri,repository],'/')
        return requests.get(url).json
        
    'GET /repository/{repository_name}/commits'
    def get_repository_commits(self,repository):
        url = string.join([self.service_url,self.repository_uri,repository,self.commits_uri],'/')
        return requests.get(url).json
    
    'GET /repository/{repository_name}/commit/{revision}'
    def get_repository_revisions(self,repository,revision):
        url = string.join([self.service_url,self.repository_uri,repository,self.commit_uri,revision],'/')
        return requests.get(url).json
   
    'GET /repository/{repository_name}/tags'
    def get_repository_tags(self, repository):
        url = string.join([self.service_url,self.repository_uri,repository,self.tags_uri],'/')
        return requests.get(url).json
    
    'GET /repository/{repository_name}/tag/{tag_name}'
    def get_tag_base(self,repository,tag):
        url = string.join([self.service_url,self.repository_uri,repository,self.tag_uri,tag],'/')
        return requests.get(url).json
    
    'GET /repository/{repository_name}/branches'
    def get_repository_branches(self,repository):
        url = string.join([self.service_url,self.repository_uri,repository,self.branches_uri],'/')
        return requests.get(url).json
    
    'GET /repository/{repository_name}/branch/{branch_name}'
    def get_branch_commits(self,repository,branch):
        url = string.join([self.service_url,self.repository_uri,repository,self.branch_uri,branch],'/')
        return requests.get(url).json
        
if __name__ == '__main__':
    pass
    