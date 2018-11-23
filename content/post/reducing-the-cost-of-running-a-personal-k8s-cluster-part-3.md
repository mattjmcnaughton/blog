+++
title = "(Part 3) Reducing the Cost of Running a Personal k8s Cluster: Conclusion"
date = "2018-11-23"
categories = ["Projects"]
thumbnail = ""
draft = true
+++

- Add graphs/images/gifs/thumbnail
- We vs you
- Don't say master node => use nodes for workers
- Proofread

## Overall impact

- Final state
  - Saved ~100 a month (from ~170 to ~80).
    - Comparison to not using k8s
      - What if I launched t2.micro instances for each pod. ($120)
      - Plus ELBs/ElasticIps
  - Encoded in source control so if I ever need to recreate this cluster, it'll
    already have the cost-optimizations.
- Restate best practices for going forward
  - Link to `cost-optimization` doc.

## Additional Future Opportunities

- Cluster auto-scaling

## Conclusion

- Kubernetes cheaper... in fact, perhaps the more cost-effective option.
