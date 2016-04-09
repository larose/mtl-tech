import collections
import json
import os
import sys

KEYWORDS_PRIORITY = [
    'tag',
    'org-name'
]

def collect_keywords(org):
    for tag in org['tags']:
        yield {
            'value': tag,
            'type': 'tag'
        }

    yield {
        'value': org['name'].replace('/', ''),
        'type': 'org-name'
    }


def get_orgs_from_dir(orgs_dir):
    orgs = {}

    for org_filename in os.listdir(orgs_dir):
        with open(os.path.join(orgs_dir, org_filename)) as org_file:
            orgs[org_filename.replace('.json', '')] = json.load(org_file)

    return orgs


def make_keywords(orgs):
    keywords = collections.defaultdict(lambda: {'orgs': []})
    for org_slug, org in orgs.items():
        for keyword in collect_keywords(org):
            keywords[keyword['value']]['orgs'].append(org_slug)
            keywords[keyword['value']]['type'] = keyword['type']

    return keywords


def make_keywords_to_orgs(keywords):
    result = collections.defaultdict(list)

    for keyword, properties in keywords.items():
        orgs = properties['orgs']
        for org in orgs:
            result[keyword.lower()].append(org)

    return result


def make_options(keywords):
    result = []

    for keyword, properties in keywords.items():
        result.append({
            'text': keyword,
            'value': keyword.lower(),
            'priority': KEYWORDS_PRIORITY.index(properties['type'])
        })

    return list(sorted(result, key=lambda k: k['value']))


def main():
    orgs_dir = sys.argv[1]
    orgs = get_orgs_from_dir(orgs_dir)
    keywords = make_keywords(orgs)
    options = make_options(keywords)
    keywords_to_orgs = make_keywords_to_orgs(keywords)

    print('var ORGS = {};'.format(
        json.dumps(
            orgs,
            ensure_ascii=False,
            indent=2)
    ))
    print('var OPTIONS = {};'.format(
        json.dumps(
            options,
            ensure_ascii=False,
            indent=2)
    ))
    print('var KEYWORDS_TO_ORGS = {};'.format(
        json.dumps(
            keywords_to_orgs,
            ensure_ascii=False,
            indent=2)
    ))

if __name__ == '__main__':
    main()
