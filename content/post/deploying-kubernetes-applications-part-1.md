+++
title = "(Part 1) Deploying Kubernetes' Applications: The Solution"
date = "2019-01-13"
categories = ["Projects"]
thumbnail = "img/deploy-solution.jpg"
draft = true
+++

# New system

Describe the new system

## How new system fulfills our requirements

Look at each component in sequence

# Migrating an application from our old system to our new system

Use grafana/blog as an example.

- Determine what we want to parameterize.
- Is it a secret?
  - NextCloud Secret
- Does it branch between dev and prod?
  - Use blog deployment

Show the template files with the biggest changes (deployment and service) and
then also deploy the small changes we make for other template files
(service-account, etc.)

# Guidelines for new system

List interesting higher level guidelines

Link to design doc listing all of them.

# Conclusion

All previous applications deployed using this system and all applications going
forward will be deployed using this system.
