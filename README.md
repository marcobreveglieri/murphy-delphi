<div>  
  <img alt="Murphy Library for Delphi" height="224" src="./Assets/logo-murphy.png">
</div>
<br />

# Murphy for Delphi

## Overview

**Murphy for Delphi** aims to be a comprehensive library designed to allow developers with the most common architectural patterns tipically implemented in *Chaos Engineering* scenarios.

This library provides ready-to-use classes that simplify the implementation of Chaos Engineering patterns in Delphi-based projects, ranging from desktop to service applications.

By leveraging Murphy library, developers and engineers can proactively test and improve the reliability and resilience of their software systems. The code empower them to uncover the most common vulnerabilities, optimize system behavior, and ensure that their applications can withstand real-world chaos scenarios, ultimately resulting in improved user experiences and increased customer satisfaction.

*** !!! Warning !!! This library is released at a very, very, very early stage and under heavy development and refactoring: you should expect possible substantial changes in the next following days. ***

### What is Chaos Engineering

With the increasing complexity of modern software systems, it has become imperative to proactively identify and address potential issues before they impact the end-users. By integrating Chaos Engineering practices into the development lifecycle, developers can build resilient and robust systems that can withstand unexpected failures and disruptions.

## Getting Started

*Section still under development*

### ⚙ Install the library

Installation is done using the [`boss install`](https://github.com/HashLoad/boss) command:
``` sh
boss install marcobreveglieri/murphy-delphi
```
If you choose to install it manually, download the source code from GitHub simply add the following folders to your project, in *Project > Options > Resource Compiler > Directories and Conditionals > Include file search path*
```
murphy-delphi/Source
```

## Patterns

*Murphy for Delphi* currently supports the following **patterns**:

+ Circuit Breaker
+ Fallback
+ Rate Limit
+ Retry Pattern

This library is still under heavy development, so new patterns and refactoring are coming soon!

## Delphi compatibility

This library works with **Delphi 11 Alexandria** as it makes use of advanced features of Delphi language, but with some slight changes it maybe could work in previous versions.

## Additional links

+ [Chaos Engineering Principles](https://principlesofchaos.org/)
