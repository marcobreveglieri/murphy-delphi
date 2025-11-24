<div>
  <img alt="Murphy Library for Delphi" width="100%" src="./Assets/logo-murphy.png">
</div>
<br />

# Murphy for Delphi

**Murphy for Delphi** is a Chaos Engineering library that implements resilience and fault-tolerance patterns for Delphi applications. Named after Murphy's Law ("Anything that can go wrong will go wrong"), it helps you build systems that gracefully handle failures like network timeouts, service outages, and resource exhaustion.

> **⚠️ Early Development Notice**
> This library is in early development (v0.1.0) and under active refactoring. Expect substantial changes in upcoming releases.

## Why Murphy?

Modern applications face inevitable failures: network issues, service unavailability, resource limits, and external dependencies going down. Murphy provides battle-tested patterns to handle these scenarios without writing complex error-handling code from scratch.

```pascal
// Automatic retry with exponential backoff - just a few lines of code!
var
  RetryPolicy: IRetryPolicy;
begin
  RetryPolicy := TRetryBuilder.Create
    .Handle([EIdHTTPProtocolException, EIdSocketError])
    .Retry(3)
    .Wait(TTimeSpan.FromSeconds(2))
    .Build;

  RetryPolicy.Execute(
    procedure
    begin
      // Your code here - automatically retried on failure
      HTTP.Get('https://api.example.com/data');
    end);
end;
```

## Key Features

- **🎯 Ready-to-Use Patterns** - Retry, Circuit Breaker, Fallback, and Rate Limit implementations
- **🔗 Fluent API** - Intuitive, chainable builder pattern for easy configuration
- **💪 Type-Safe** - Leverages Delphi generics for compile-time type safety
- **🎭 Exception Filtering** - Handle only specific exception types
- **🧪 Testable** - Built-in test mode eliminates delays for fast unit testing
- **🔄 Composable** - Combine multiple patterns for sophisticated resilience strategies
- **📦 Zero Dependencies** - Only requires Delphi RTL

## Installation

### Using Boss Package Manager (Recommended)

```bash
boss install marcobreveglieri/murphy-delphi
```

### Manual Installation

1. Download or clone the repository from GitHub
2. Add `murphy-delphi/Source` to your project's search path:
   - **Project > Options > Delphi Compiler > Search path**
   - Or add to IDE's global library path: **Tools > Options > Language > Delphi > Library**

## Patterns

Murphy implements four essential resilience patterns:

### Retry Pattern

Automatically retries failed operations with configurable delays - perfect for transient failures.

```pascal
uses Murphy.Policy.Retry;

var
  Policy: IRetryPolicy;
begin
  Policy := TRetryBuilder.Create
    .Handle(EDatabaseError)
    .Retry(3)
    .Wait(TTimeSpan.FromSeconds(1))
    .Build;

  Policy.Execute(procedure begin Database.Connect; end);
end;
```

**Use cases**: Network requests, database connections, temporary service unavailability

### Circuit Breaker Pattern

Prevents cascading failures by blocking calls to failing services temporarily.

```pascal
uses Murphy.Policy.CircuitBreaker;

var
  Policy: ICircuitBreakerPolicy;
begin
  Policy := TCircuitBreakerBuilder.Create
    .Handle(Exception)
    .Fail(5)                              // Open after 5 failures
    .Within(TTimeSpan.FromSeconds(30))   // Auto-close after 30s
    .Build;

  Policy.Execute(procedure begin CallExternalService; end);
end;
```

**Use cases**: External API calls, protecting downstream services, fast-fail scenarios

### Fallback Pattern

Provides alternative results when operations fail - return cached data or defaults.

```pascal
uses Murphy.Policy.Fallback;

var
  Policy: IFallbackPolicy<string>;
  Result: string;
begin
  Policy := TFallbackBuilder<string>.Create
    .Handle(Exception)
    .Fallback(function: string
              begin
                Result := GetCachedData; // Return fallback value
              end)
    .Build;

  Result := Policy.Execute(function: string
                            begin
                              Result := FetchFromAPI;
                            end);
end;
```

**Use cases**: API with fallback to cache, default values, degraded functionality

### Rate Limit Pattern

Controls operation rate to prevent resource exhaustion and API throttling.

```pascal
uses Murphy.Policy.RateLimit;

var
  Policy: IRateLimitPolicy;
begin
  Policy := TRateLimitBuilder.Create
    .Allow(100)                          // 100 calls
    .Within(TTimeSpan.FromMinutes(1))   // Per minute
    .Build;

  Policy.Execute(procedure begin MakeAPICall; end);
end;
```

**Use cases**: API rate limiting, resource protection, preventing system overload

## Quick Start

1. **Install Murphy** using Boss or manually
2. **Add the unit** to your uses clause: `Murphy.Policy.Retry`
3. **Create a policy** using the builder pattern
4. **Execute your code** within the policy

See the [Getting Started Guide](Docs/02-Getting-Started.md) for detailed examples and the [Demo Application](Demos/00_Primer) for interactive examples of all patterns.

## Documentation

Comprehensive documentation is available in the [Wiki section](https://github.com/marcobreveglieri/murphy-delphi/wiki).

## Demo Application

Explore the demo in `Demos/00_Primer/Murphy.Demos.Primer.dpr` to see the patterns in action with some examples.

## License

Murphy for Delphi is released under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please see the [Contributing Guide](Docs/Advanced/Contributing.md) for details.

## Support & Resources

- **GitHub Repository**: [marcobreveglieri/murphy-delphi](https://github.com/marcobreveglieri/murphy-delphi)
- **Issues & Bug Reports**: [GitHub Issues](https://github.com/marcobreveglieri/murphy-delphi/issues)
- **Chaos Engineering Principles**: [principlesofchaos.org](https://principlesofchaos.org/)

---

> [!IMPORTANT]
>
> Some of this documentation was generated or reworked with an LLM tool (Claude). It may therefore contain errors and/or inaccuracies. If you encounter any, please report the issue or propose a fix by submitting a pull request.
