'''
Created on Jun 4, 2012

@author: yelkalay
@summary: Basic Python client demonstrating the GitGoggles Python libray capabilities. 
'''

import pprint
from gitgoggles import GitGoggles

def main():
    service_url = 'http://localhost:9292'
    goggles = GitGoggles(service_url)
    pp = pprint.PrettyPrinter(indent=4)
    
    'Obtain a list of all repositories'
    repositories_list = goggles.get_all_repositories()['repositories']
    print 'Repositories List:'
    pp.pprint(repositories_list)
    
    'Select an element (e.g. a repository name) from the list of repositories'
    repo_name = repositories_list[0]
    print 'Repository Name: ' + repo_name
    
    'Obtain a list of all branches in the repositories tree'
    master_branches_list = goggles.get_repository_tree(repo_name)['branches']
    print 'Master Branches List:'
    pp.pprint(master_branches_list)
       
    'Obtain a list of all commits made on a branch'
    commits_list = goggles.get_repository_commits(repo_name)
    print 'All Commits:'
    pp.pprint(commits_list)
    
    'Obtain a SHA1 revision of the first commit in the list'
    revision = commits_list[0]['sha']
    print 'Revision ID:' + revision
    
    'Obtain revision log of single revision'
    revision_log = goggles.get_repository_revisions(repo_name, revision)
    print 'Revision Log:'
    pp.pprint(revision_log)
    
    'Obtain list of repository tags'
    tag_list = goggles.get_repository_tags(repo_name)
    print 'List of Tags:'
    pp.pprint(tag_list)
    
    'Select an element from the list of tags'
    tag = None
    if (len(tag_list) > 0):
        tag = tag_list[0]
        print 'Tag:' + tag 
    
    'Obtain the tag origin information'
    if(tag is not None):
        tag_origin = goggles.get_tag_base(repo_name, tag)
        pp.pprint(tag_origin)
    
    'Obtain list of all repository branches'
    branch_list = goggles.get_repository_branches(repo_name)
    print 'List of Branches:'
    pp.pprint(branch_list)
    
    'Select an element from the list of branches'
    branch = branch_list[0]
    print 'Branch:' + branch
    
    'Obtain all commits made on branch'
    branch_info = goggles.get_branch_commits(repo_name, branch)
    print 'Branch Revision Log:'
    pp.pprint(branch_info)

if __name__ == '__main__':
    main()