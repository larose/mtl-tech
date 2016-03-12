import collections
import json
import os
import sys


def generate_partial(keyword):
    for i in range(1, len(keyword) + 1):
        yield keyword[:i]

def get_keywords(keywords_dir):
    for filepath in os.listdir(keywords_dir):
        yield filepath.replace('.json', '')

def main():
    keywords_dir = sys.argv[1]
    partial_keywords_dir = sys.argv[2]

    partials = collections.defaultdict(list)

    for keyword in get_keywords(keywords_dir):
        for partial in generate_partial(keyword):
            partials[partial].append(keyword)

    for partial, keywords in partials.items():
        keywords = sorted(keywords)
        with open(os.path.join(partial_keywords_dir, partial + '.json'), 'w') as file:
            json.dump(keywords, file, ensure_ascii=False)
            file.write('\n')

if __name__ == '__main__':
    main()
