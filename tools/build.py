#! /usr/bin/env python
"""Script to build the web.org website.
"""
import os
import markdown
import re
import web

link_re = web.re_compile(r'(?<!\\)\[\[(.*?)(?:\|(.*?))?\]\]')
class wikilinks:
    """markdown postprocessor for [[wikilink]] support."""
    def process_links(self, node):
        doc = node.doc
        text = node.value
        new_nodes = []
        position = [0]

        def mangle(match):
            start, end = position[0], match.start()
            position[0] = match.end()
            text_node = doc.createTextNode(text[start:end])

            matches = match.groups()
            link = matches[0]
            anchor = matches[1] or link
            
            if not link.startswith("/") and not link.startswith("http"):
                link = "/" + link

            link_node = doc.createElement('a')
            link_node.setAttribute('href', link)
            link_node.setAttribute('class', 'internal')
            link_node.appendChild(doc.createTextNode(anchor))

            new_nodes.append(text_node)
            new_nodes.append(link_node)

            return ''

        re.sub(link_re, mangle, text)

        start = position[0]
        end = len(text)
        text_node = doc.createTextNode(text[start:end])

        new_nodes.append(text_node)

        return new_nodes

    def replace_node(self, node, new_nodes):
        """Removes the node from its parent and inserts new_nodes at that position."""
        parent = node.parent
        position = parent.childNodes.index(node)
        parent.removeChild(node)

        for n in new_nodes:
            parent.insertChild(position, n)
            position += 1

    def run(self, doc):
        def test(e):
            return e.type == 'text' and link_re.search(e.value)

        for node in doc.find(test):
            new_nodes = self.process_links(node)
            self.replace_node(node, new_nodes)

def format(text):
    text = web.safeunicode(text)
    md = markdown.Markdown(source=text)
    md.postprocessors.append(wikilinks())
    
    return web.safestr(md.convert())
    
root = os.path.dirname(__file__)
render = web.template.frender(os.path.join(root, "site.html"), globals={"format": format})

def write(path, text):
    print "writing", path
    dir = os.path.dirname(path)
    if not os.path.exists(dir):
        os.makedirs(dir)
    f = open(path, "w")
    f.write(text)
    f.close()
    
def get_title(path, body):
    if body.strip().startswith("#"):
        title = body.splitlines()[0].strip()[1:].strip()
    else:
        title = os.path.basename(path).split("/")[-1].replace("_", " ").title()
    return title

def render_page(path):
    body = open(path).read()
    title = get_title(path, body)
    page = web.storage(title=title, body=body)
    html = web.safestr(render(page))
    
    html_path = "html/" + path.split("/", 1)[1]
    
    if not path.endswith("/index"):
        html_path += "/index.html"
    else:
        html_path += ".html"
    
    write(html_path, html)

def main():
    for dirpath, dirnames, filenames in os.walk("pages"):
        for f in filenames:
            render_page(os.path.join(dirpath, f))
    os.system("cp -r static html")
    
if __name__ == '__main__':
    main()
