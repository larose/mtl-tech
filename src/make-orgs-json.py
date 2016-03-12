import functools
import json
import os
import sys

def get_orgs(orgs_dir):
    orgs = {}

    for org_filename in os.listdir(orgs_dir):
        with open(os.path.join(orgs_dir, org_filename)) as file:
            orgs[org_filename.replace('.json', '')] = json.load(file)

    return orgs

def main():
    orgs_dir = sys.argv[1]
    orgs_filename = sys.argv[2]

    orgs = get_orgs(orgs_dir)

    with open(orgs_filename, 'w') as file:
        json.dump(orgs, file, ensure_ascii=False, indent=4)
        file.write('\n')



if __name__ == '__main__':
    main()
