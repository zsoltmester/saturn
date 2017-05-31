import requests
from bs4 import BeautifulSoup

def get_possible_site_urls(raw_url):
    site_urls = []

    # set up the schema, if none given
    if raw_url.startswith('http://') or raw_url.startswith('https://'):
        site_urls.append(raw_url)
        if '://www.' not in raw_url:
            site_urls.append(raw_url.replace('://','://www.'))
    else:
        if raw_url.startswith('www.'):
            site_urls.append('https://' + raw_url)
            site_urls.append('http://' + raw_url)
        else:
            site_urls.append('https://' + raw_url)
            site_urls.append('https://www.' + raw_url)
            site_urls.append('http://' + raw_url)
            site_urls.append('http://www.' + raw_url)

    return site_urls

def print_feeds_for_site(raw_url):
    print('----------------------------')
    print(raw_url)

    site_urls = get_possible_site_urls(raw_url)
    print('site_urls: ', site_urls)

    feeds = []

    headers = {'user-agent': 'Chrome/58'}

    for site_url in site_urls:

        try:
            response = requests.get(site_url, headers=headers)
        except Exception as error:
            continue

        if response.status_code != 200:
            continue

        site_source = BeautifulSoup(response.text, 'html.parser')

        for link_with_rss_feed in site_source.find_all('link', {'type' : 'application/rss+xml'}):
            rss_feed = link_with_rss_feed.get('href')
            feeds.append('RSS: ' + str(rss_feed))

        for link_with_atom_feed in site_source.find_all('link', {'type' : 'application/atom+xml'}):
            atom_feed = link_with_atom_feed.get('href')
            feeds.append('Atom: ' + str(atom_feed))

        break

    print('feeds: ', feeds)

print_feeds_for_site('index.hu')
print_feeds_for_site('www.hvg.hu')
print_feeds_for_site('http://hvg.hu/egyeb/rss')
print_feeds_for_site('http://444.hu')
print_feeds_for_site('http://www.mobilarena.hu')
print_feeds_for_site('https://nytimes.com')
print_feeds_for_site('theverge.com')
print_feeds_for_site('theguardian.com')
print_feeds_for_site('techcrunch.com')
