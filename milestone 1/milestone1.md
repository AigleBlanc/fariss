---
title: MACS 40800 1 Unsupervised Machine Learning
subtitle: "Milestone 1: Selecting the Paper"
author: "*Essosolim Apollinaire Abi*"
date: "May 1, 2026"
geometry: "margin=1in"
fontsize: 11pt
colorlinks: true
linkcolor: "MidnightBlue"
urlcolor: "MidnightBlue"
---

Fariss, Christopher J. 2014. "Respect for Human Rights has Improved Over Time: Modeling the Changing Standard of Accountability." *American Political Science Review* 108 (2): 297--318. <https://doi.org/10.1017/S0003055414000070>. Replication archive on Harvard Dataverse: <https://doi.org/10.7910/DVN/25830>.


# Fariss' Argument 

Christopher Fariss challenges a very important argument that posits that, on average, respect for physical integrity rights has not improved since 1976. He provides a novel methodology for measuring respect for physical integrity human rights at the country-year level over the entire post-war period (1949–2010). The proposed measure, a Bayesian dynamic ordinal Item Response Theory (DO-IRT) model, was first introduced in a paper he co-authored to provide evidence that it fits the indicators of state repression measured by monitors like Amnesty International and the U.S. State Department. In this paper, he shows that the seemingly non-increasing trend in latent physical integrity respect is in fact an effect of assuming that item difficulty is constant over time. The difficulty here can be interpreted as the probability of a given level of repression being observed and coded by monitoring agencies, conditional on the true underlying level of repression. Allowing this probability (i.e., the item difficulty cutpoints) to vary over time contradicts prior conclusions about non-improving respect for human rights. Fariss calls the model with time-varying item difficulty cutpoints the dynamic standard model and the model with constant difficulty the constant standard model. He shows that the dynamic standard model fits the observed repression data better than the constant standard model. He also provides a strong non-data-driven argument that the standards used to assess state behaviors are becoming more stringent over time, as monitors are increasingly able to “look harder for abuse, look in more places for abuse, and classify more acts as abuse.” In conclusion, respect for human rights is not stagnant. A dynamic DO-IRT model that allows for varying item difficulty more accurately measures state respect for human rights, and this model shows that respect has improved over time.

# Data Access

The data are assembled from nine publicly available source datasets distributed alongside the replication archive on Harvard Dataverse, all keyed on (Correlates-of-War country code, year). The data and replication code are available at this link: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/25830. The merged panel covers roughly 200 countries over 62 years for 9,267 country-year observations and a total of \~1 MB of raw CSV across thirteen indicators. There is extensive missingness in the data since most country-years are observed on only a handful of items. The nine source datasets are:

1. **CIRI Human Rights Dataset** (Cingranelli and Richards 1981-2011). Four ordinal items capturing physical-integrity violations: disappearance, extrajudicial killing, political imprisonment, and torture. Each measure is scored  0-2 by human coders reading State Department and Amnesty country reports.
2. **Political Terror Scale** (Gibney, Cornett, and Wood 1976-2011). Two ordinal scores (1-5) reflecting the level of state-sanctioned political violence, coded independently from Amnesty International country reports and the U.S. State Department's Country Reports on Human Rights Practices.
3. **Hathaway Torture Index** (Hathaway 2002). A single ordinal indicator (1-5) of the prevalence of state torture, drawn from her *Yale Law Journal* analysis of treaty compliance.
4. **Ill-Treatment and Torture data** (Conrad and Moore 1995-2005). A six-level ordinal scale capturing the frequency and severity of allegations of state torture from Amnesty International Urgent Action appeals.
5. **PITF Genocide and Politicide events** (Marshall, Gurr, and Harff 1956-2010). A binary indicator coded 1 in country-years for which the Political Instability Task Force identifies an ongoing genocidal or politicidal episode.
6. **Rummel's democide series** (Rummel 1949-1987). A binary indicator marking country-years with documented mass killing by the state, drawn from Rummel's *Statistics of Democide*.
7. **UCDP One-Sided Violence dataset** (Eck and Hultman 1989-2011). A binary indicator marking country-years in which the government deliberately killed at least 25 unarmed civilians.
8. **Harff and Gurr Massive Repression panel** (Harff and Gurr 1949-1988). A binary indicator marking country-years exhibiting "massive" state repression as defined by Harff and Gurr's coding rules.
9. **World Handbook of Political and Social Indicators** (Taylor and Jodice 1949-1982). A binary indicator marking country-years with one or more documented political executions.

These indicators fall into two different groups, and this distinction is central to the paper. The first group (CIRI, PTS, Hathaway, ITT) consists of standards-based measures: human-coded ordinal scales whose meaning changes over time as coding standards evolve. The second group consists of event-based measures: binary indicators of extreme violence whose meaning is more stable over time.

Fariss' model allows the standards-based measures to have time-varying thresholds, while keeping the thresholds for event-based measures fixed. This is what allows the model to separately identify changes in reporting standards from changes in true human rights conditions. Without the event-based measures as anchors, it would be impossible to tell whether changes in the data reflect real improvements or just stricter reporting.

# Methodology

Methodologically, Fariss estimates a Bayesian dynamic ordinal Item Response Theory (D0-IRT) model to measure a country’s level of respect for physical integrity rights. Each country \( i \) in year \( t \) has a latent score \( \theta_{it} \), which represents its true (unobserved) level of human rights respect. Each observed indicator \( j \) (e.g., torture, killings) is linked to this latent score through two parameters: a discrimination parameter \( \beta_j \), and a set of cutpoints \( \alpha \) that determine how the latent score maps into observed categories. The key innovation is how the model treats these cutpoints. For standards-based indicators (e.g., CIRI, PTS), the cutpoints are allowed to vary over time. This captures the idea that reporting standards change, so the same level of repression may be coded more harshly in later years. For event-based indicators (e.g., genocide, mass killings), the cutpoints are held constant, since these events are easier to observe and their meaning is more stable over time.

Both types of data are used together in a single model. The event-based indicators act as anchors, helping identify the latent trend in repression, while the standards-based indicators are adjusted for changes in reporting standards. Without these anchors, it would be impossible to distinguish real changes in human rights from changes in how they are measured.

Fariss compares the two models: a constant standard model, where all cutpoints are fixed over time, and a dynamic standard model, where cutpoints for standards-based indicators vary over time. The models are estimated using Bayesian methods (MCMC in JAGS), and their fit is compared using standard model comparison techniques.

The results show that the dynamic standard model fits the data much better. More importantly, it reveals a different trend: once changes in reporting standards are accounted for, respect for physical integrity rights has improved over time. The apparent lack of improvement in earlier studies is therefore due to measurement bias, not stagnation in human rights.
