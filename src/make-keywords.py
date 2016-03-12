import collections
import json
import os
import sys

def generate_keywords(org):
    for tag in org['tags']:
        yield tag

    yield org['name'].replace('/', '')

def lower(keywords):
    for k in keywords:
        yield k.lower()

def main():
    keywords_dir = sys.argv[1]

    orgs = json.load(sys.stdin)

    keywords = collections.defaultdict(list)
    for slug, org in orgs.items():
        for keyword in lower(generate_keywords(org)):
            keywords[keyword].append(slug)

    for key, orgs in keywords.items():
        with open(os.path.join(keywords_dir, key + '.json'), 'w') as file:
            json.dump(sorted(orgs), file, ensure_ascii=False)
            file.write('\n')


if __name__ == '__main__':
    main()
