---
layout: page
permalink: /repositories/
title: repositories
description:
nav: true
nav_order: 4
---

{% if site.data.repositories.github_repos %}

## GitHub Repositories

<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center mb-3">
  {% for repo in site.data.repositories.github_repos %}
    {% include repository/repo.liquid repository=repo %}
  {% endfor %}
</div>

<ul class="list-unstyled" id="repositories-fallback-list">
  {% for repo in site.data.repositories.github_repos %}
    {% assign repository_parts = repo | split: "/" %}
    <li class="mb-1">
      <a href="https://github.com/{{ repo }}">{{ repository_parts[1] | default: repo }}</a>
    </li>
  {% endfor %}
</ul>
{% endif %}
