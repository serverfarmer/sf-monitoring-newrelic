## Deprecated

This repository contains old, deprecated extension to Server Farmer.


## History of New Relic support in Server Farmer

### 2012-2015

New Relic was used by Server Farmer authors since around 2012-13 - in fact, we were its early adopters in Allegro.pl (of paid version, at larger scale). And then we also wanted to implement it (in free version) as an automated service discovery, monitoring and alerting platform for our side customers.

Initial implementations for particular customers were made in 2013 - and the final, universal implementation in Server Farmer, meeting its code quality and separation from customer-specific stuff, was finished around 2014-15.

We also created a few New Relic Plugins, integrated with Server Farmer:

- for monitoring hard drive SMART metrics
- for moniroring MySQL server metrics (using [New Relic Platform MySQL Plugin - Java](https://github.com/newrelic/newrelic_mysql_java_plugin))
- for monitoring [backup collectors](https://github.com/serverfarmer/sm-backup-collector) and alerting about backup failures
- for visualizing [Pastebin.com](https://pastebin.com/) public paste volume (this integration was private)

### 2017-2018

In 2017 we had New Relic Servers (now referred as the "old" platform), with basic alerting, enabled on **over 1000 hosts**:

- for many various customers
- using many separate New Relic accounts (our own + per customer)
- with completely different alerting policies and integrations for each customer
- for Linux and Windows
- 100% free (with 1 exception: 1 customer paid for 2 hosts for 1 month, to solve a particular problem with MySQL)

Unfortunately, in 2017, after gaining a sufficiently large group of paid clients, New Relic started to cut down their really-free services and replacing them with either 30-day free trials, or (later) services with limited free volume. It was first announced here, and our protests were completely ignored:

https://discuss.newrelic.com/t/important-upcoming-changes-for-new-relic-servers-and-legacy-alerting-features/49474

### Our reaction

We decided to replace New Relic Servers with combination of 3 separate services:

1. Heartbeat subproject (implementation finished in 2018) - for [service discovery](https://github.com/serverfarmer/heartbeat-linux), and [heartbeat service](https://github.com/serverfarmer/heartbeat-server) itself. So each server reports to Heartbeat every 2 minutes, what was detected to be alive.

2. Any internal or external monitoring service (possibly separate for each customer) - to query Heartbeat server and send email/push/Slack/Teams alerts about dead services. We choosed [UptimeRobot](https://uptimerobot.com/), since back then, it was almost 10x cheaper than competing [StatusCake](https://www.statuscake.com/) and [Pingdom](https://www.pingdom.com/) (at least for bigger plans), while having enough quality.

3. [Cacti](https://www.cacti.net/) for recording metrics, where it was really required.

We also decided to drop most raw metrics and convert them to simple boolean alive/dead statuses on-the-fly in Heartbeat - eg. a hard drive either meets basic quality requirements, or not (see [the details](https://github.com/serverfarmer/heartbeat-linux#smart-monitoring-details)).

At that time, we didn't touch New Relic Plugins.

### 2019-2022

In early 2021, New Relic made another announcement, about New Relic Plugins:

https://discuss.newrelic.com/t/new-relic-plugin-eol-wednesday-june-16th-2021/127267

Fortunately, we managed to migrate all remaining monitoring services from New Relic to other platforms yet in 2019, so it didn't affect our customers at all.

In 2022, as a part of the new roadmap for Server Farmer, we plan to finally remove several features deprecated in past years, including anything related to New Relic.
