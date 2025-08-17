# it-works-on-my-machine
Senior Release Engineer Assignment - Production-ready microservice with comprehensive CI/CD

# 🚀 it-works-on-my-machine

> **From "It works on my machine" to "It works everywhere!"** - A production-ready microservice demonstrating comprehensive CI/CD practices.

[![CI/CD Pipeline](https://github.com/royhershko/it-works-on-my-machine/workflows/🚀%20CI%2FCD%20Pipeline/badge.svg)](https://github.com/royhershko/it-works-on-my-machine/actions)

## 📋 Overview

This is a Node.js Express microservice that has been transformed from a simple local development project into a production-ready system with comprehensive CI/CD practices. The service demonstrates modern DevOps principles including automated testing, code quality gates, security scanning, and zero-downtime deployments.

## 🎯 Project Goals

**Assignment Context:** Senior Release Engineer Home Assignment - "It Works on My Machine" → "It Works Everywhere!"

The challenge was to take a basic microservice and implement production-ready CI/CD practices that follow industry standards.

## ✨ Features

### 🔧 Core Application
- **Express.js** server with multiple endpoints
- **Health checks** and readiness probes  
- **Metrics** endpoint for monitoring
- **Graceful shutdown** handling
- **Security headers** and best practices
- **Structured logging** and error handling

### 🏗️ Production-Ready Infrastructure
- **Multi-stage Docker** builds for optimal images
- **Non-root user** execution for security
- **Health checks** built into containers
- **Environment-specific** configurations

### 🔄 CI/CD Pipeline Features
- **Automated testing** with Jest and Supertest
- **Code quality gates** with ESLint and Prettier
- **Security scanning** with npm audit
- **Multi-environment deployment** (staging/production)
- **Container registry** with GitHub Packages

## 🚀 Quick Start

### Prerequisites
- Node.js >= 18.0.0
- npm >= 8.0.0
- Docker (optional)

### Local Development

```bash
# Clone the repository
git clone https://github.com/royhershko/it-works-on-my-machine.git
cd it-works-on-my-machine

# Install dependencies
npm install

# Start development server
npm start

# Run tests
npm test

# Run with coverage
npm run test:coverage
```

### Docker Development

```bash
# Build production image
docker build -t it-works-prod .

# Run production container
docker run -p 3000:3000 it-works-prod
```

## 🛠️ API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Service information and status |
| `/health` | GET | Health check with detailed info |
| `/ready` | GET | Readiness probe |
| `/version` | GET | Version and build information |
| `/metrics` | GET | Basic application metrics |

### Example Response

```bash
curl http://localhost:3000/health
```

```json
{
  "status": "healthy",
  "message": "Still working... on *my* machine 🧃",
  "uptime": 42.123,
  "timestamp": "2025-08-17T16:30:45.123Z",
  "version": "1.0.0",
  "environment": "development"
}
```

## 🔄 CI/CD Strategy & Reasoning

### 🏗️ Pipeline Architecture

Our CI/CD pipeline follows a **comprehensive, security-first approach** with multiple quality gates:

```
Code Push → Test & Quality → Build Container → Security Scan → Deploy
```

### 🎯 Key Principles

1. **Production-Ready Thinking**
   - Every commit could go to production
   - Comprehensive testing before deployment
   - Zero-downtime deployment strategies

2. **Industry Best Practices**
   - Multi-stage Docker builds
   - Security scanning at every stage
   - Code quality gates with failure conditions
   - Automated rollback capabilities

3. **Clear Communication**
   - Detailed pipeline logs and status
   - Comprehensive documentation
   - Notification systems for deployments

4. **Decision-Making Process**
   - Environment progression (dev → staging → production)
   - Quality gates that can fail the pipeline
   - Manual approval for production deployments

### 🔍 Quality Gates

1. **Code Quality**
   - ESLint for code standards
   - Prettier for consistent formatting

2. **Testing**
   - Unit tests with Jest
   - Integration tests with Supertest
   - Health check validation

3. **Security**
   - npm audit for dependency vulnerabilities
   - Security headers validation
   - Container scanning

4. **Performance**
   - Health check validation
   - Container resource limits
   - Startup time monitoring

## 🛡️ Security Features

- **Non-root container execution**
- **Multi-stage builds** minimizing attack surface
- **Security headers** (HSTS, CSP, etc.)
- **Dependency vulnerability scanning**
- **Container image scanning**
- **Secrets management** with GitHub Secrets

## 📊 Monitoring & Observability

- **Health checks** for liveness/readiness
- **Metrics endpoint** for monitoring integration
- **Structured logging** with timestamps
- **Error tracking** with proper status codes
- **Performance metrics** (CPU, memory, uptime)

## 🔄 Deployment Strategy

### Environment Progression
1. **Development** - Feature branches and local development
2. **Staging** - Integration testing environment (develop branch)
3. **Production** - Live environment (main branch)

### Deployment Process
1. **Build** - Multi-stage Docker build
2. **Test** - Automated testing and quality checks
3. **Security Scan** - Container and dependency scanning
4. **Deploy** - Zero-downtime deployment
5. **Verify** - Health checks and smoke tests
6. **Monitor** - Continuous monitoring and alerting

### Rollback Strategy
- **Tagged images** for easy version rollback
- **Health check failures** trigger automatic rollback
- **Manual rollback** capability through GitHub Actions
- **Database migration** rollback procedures (when applicable)

## 🧪 Testing Strategy

### Test Types
- **Unit Tests** - Individual function testing
- **Integration Tests** - API endpoint testing
- **Health Check Tests** - Service availability testing
- **Security Tests** - Vulnerability and header validation

### Coverage Requirements
- All critical paths covered
- Error handling scenarios tested
- Security headers validation

## 📁 Project Structure

```
it-works-on-my-machine/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # Main CI/CD pipeline
├── scripts/                   # Deployment scripts
├── server.js                  # Main application file
├── server.test.js             # Test suite
├── package.json               # Node.js dependencies & scripts
├── Dockerfile                 # Multi-stage container build
├── .gitignore                 # Git exclusions
├── test.sh                    # Health check script
└── README.md                  # This file
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `PORT` | Server port | `3000` | No |
| `NODE_ENV` | Environment | `development` | No |
| `VERSION` | App version | `1.0.0` | No |
| `BUILD_NUMBER` | Build number | `dev` | No |
| `GIT_COMMIT` | Git commit hash | `unknown` | No |
| `BUILD_DATE` | Build timestamp | Current time | No |

## 📈 What I'd Do Differently with Unlimited Time/Resources

1. **Enhanced Monitoring**
   - Prometheus metrics integration
   - Grafana dashboards
   - Distributed tracing with Jaeger
   - Custom alerting rules

2. **Advanced Security**
   - Container image signing with Cosign
   - SAST/DAST security testing
   - Dependency license scanning
   - Runtime security monitoring

3. **Infrastructure as Code**
   - Kubernetes manifests
   - Helm charts for deployment
   - Terraform for infrastructure
   - GitOps workflow with ArgoCD

4. **Advanced CI/CD Features**
   - Canary deployments
   - Feature flags integration
   - A/B testing framework
   - Automated performance testing

5. **Enhanced Developer Experience**
   - Local development with Docker Compose
   - VS Code dev containers
   - Automated changelog generation
   - Integration with project management tools

## 🚀 Getting Started with Your Own Instance

1. **Fork this repository**
2. **Update the GitHub repository references** in README.md
3. **Push to main branch** to trigger the pipeline

## 📞 Support & Questions

If you have questions about the requirements or need clarification on what's expected, don't hesitate to reach out.

Email: yoni.zabari@unity3d.com

---

**Ready to turn "it works on my machine" into "it works everywhere"?** 🚀

*Senior Release Engineer Assignment by Roy Hershko*
