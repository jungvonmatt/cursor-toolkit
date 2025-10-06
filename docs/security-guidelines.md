# Security Guidelines for GenAI projects

## Core Security Principles
- **Defense in Depth**: Implement multiple layers of security controls
- **Least Privilege**: Grant minimum necessary permissions
- **Zero Trust**: Never trust, always verify
- **Secure by Default**: Security must be built-in, not bolted-on
- **Attack Surface Minimization**: Reduce exposed functionality to essentials

## FastAPI Backend Security

### 1. Authentication & Authorization

#### JWT Token Security
```python
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError, jwt
from datetime import datetime, timedelta
from typing import Optional

# Use strong secret keys from environment
SECRET_KEY = os.getenv("JWT_SECRET_KEY")  # Min 256-bit key
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Implement token validation
security = HTTPBearer()

async def verify_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication credentials"
            )
        # Verify token expiration
        exp = payload.get("exp")
        if exp and datetime.utcfromtimestamp(exp) < datetime.utcnow():
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token has expired"
            )
        return user_id
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials"
        )

# Apply to routes
@router.get("/protected")
async def protected_route(user_id: str = Depends(verify_token)):
    return {"user_id": user_id}
```

#### Role-Based Access Control (RBAC)
```python
from enum import Enum
from functools import wraps

class UserRole(str, Enum):
    ADMIN = "admin"
    CONSULTANT = "consultant"
    CUSTOMER = "customer"

def require_role(allowed_roles: list[UserRole]):
    def decorator(func):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            # Extract user from token
            user = kwargs.get("current_user")
            if not user or user.role not in allowed_roles:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Insufficient permissions"
                )
            return await func(*args, **kwargs)
        return wrapper
    return decorator

# Usage
@router.delete("/admin/users/{user_id}")
@require_role([UserRole.ADMIN])
async def delete_user(user_id: str, current_user: User = Depends(get_current_user)):
    # Only admins can access this endpoint
    pass
```

### 2. Input Validation & Sanitization

#### Pydantic Models for Strict Validation
```python
from pydantic import BaseModel, validator, constr, EmailStr, SecretStr
from typing import Optional
import re

class UserCreate(BaseModel):
    username: constr(min_length=3, max_length=50, regex="^[a-zA-Z0-9_-]+$")
    email: EmailStr
    password: SecretStr
    phone: Optional[constr(regex="^\\+?[1-9]\\d{1,14}$")] = None
    
    @validator('password')
    def validate_password(cls, v):
        password = v.get_secret_value()
        if len(password) < 8:
            raise ValueError('Password must be at least 8 characters long')
        if not re.search(r"[A-Z]", password):
            raise ValueError('Password must contain at least one uppercase letter')
        if not re.search(r"[a-z]", password):
            raise ValueError('Password must contain at least one lowercase letter')
        if not re.search(r"\d", password):
            raise ValueError('Password must contain at least one digit')
        if not re.search(r"[!@#$%^&*(),.?\":{}|<>]", password):
            raise ValueError('Password must contain at least one special character')
        return v

    class Config:
        # Prevent extra fields
        extra = "forbid"
```

#### SQL Injection Prevention
```python
from sqlalchemy import text
from sqlalchemy.orm import Session

# ❌ NEVER do this - vulnerable to SQL injection
@router.get("/users/search")
async def bad_search(name: str, db: Session = Depends(get_db)):
    query = f"SELECT * FROM users WHERE name = '{name}'"  # DANGEROUS!
    return db.execute(text(query)).fetchall()

# ✅ Use parameterized queries
@router.get("/users/search")
async def safe_search(name: str, db: Session = Depends(get_db)):
    # Using SQLAlchemy ORM (recommended)
    users = db.query(User).filter(User.name == name).all()
    
    # Or with parameterized raw SQL if needed
    query = text("SELECT * FROM users WHERE name = :name")
    users = db.execute(query, {"name": name}).fetchall()
    
    return users
```

### 3. API Rate Limiting

```python
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

# Configure rate limiter
limiter = Limiter(
    key_func=get_remote_address,
    default_limits=["100 per minute"]
)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# Apply rate limiting to sensitive endpoints
@router.post("/auth/login")
@limiter.limit("5 per minute")  # Prevent brute force
async def login(request: Request, credentials: LoginCredentials):
    pass

@router.post("/auth/register")
@limiter.limit("3 per hour")  # Prevent spam registrations
async def register(request: Request, user_data: UserCreate):
    pass
```

### 4. CORS Configuration

```python
from fastapi.middleware.cors import CORSMiddleware

# Configure CORS strictly
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://vision-guide.com",
        "https://www.vision-guide.com",
        # Only add localhost for development
        "http://localhost:3000" if os.getenv("ENVIRONMENT") == "development" else None
    ],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["Authorization", "Content-Type"],
    max_age=3600,  # Cache preflight requests
)
```

### 5. Error Handling & Information Disclosure

```python
import logging
from fastapi import Request
from fastapi.responses import JSONResponse

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Generic error handler - don't leak sensitive info
@app.exception_handler(Exception)
async def generic_exception_handler(request: Request, exc: Exception):
    # Log full error internally
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    
    # Return generic error to client
    return JSONResponse(
        status_code=500,
        content={
            "detail": "An internal server error occurred",
            "request_id": request.headers.get("X-Request-ID")
        }
    )

# Specific error handling
@app.exception_handler(ValueError)
async def value_error_handler(request: Request, exc: ValueError):
    # Log error
    logger.warning(f"Validation error: {exc}")
    
    # Return sanitized error
    return JSONResponse(
        status_code=400,
        content={"detail": "Invalid input provided"}
    )
```

## Frontend Security

### 1. XSS Prevention

```typescript
// ❌ NEVER render raw HTML
const DangerousComponent = ({ userContent }: { userContent: string }) => {
    return <div dangerouslySetInnerHTML={{ __html: userContent }} />;
};

// ✅ Use React's built-in escaping
const SafeComponent = ({ userContent }: { userContent: string }) => {
    return <div>{userContent}</div>;
};

// ✅ If HTML rendering is necessary, sanitize first
import DOMPurify from 'dompurify';

const SanitizedComponent = ({ htmlContent }: { htmlContent: string }) => {
    const sanitized = DOMPurify.sanitize(htmlContent, {
        ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'p', 'br'],
        ALLOWED_ATTR: []
    });
    
    return <div dangerouslySetInnerHTML={{ __html: sanitized }} />;
};
```

### 2. Content Security Policy (CSP)

```typescript
// Configure CSP headers (in backend or CDN)
const cspHeader = {
    "Content-Security-Policy": [
        "default-src 'self'",
        "script-src 'self' 'unsafe-inline' 'unsafe-eval'",  // Avoid unsafe-* in production
        "style-src 'self' 'unsafe-inline'",
        "img-src 'self' data: https:",
        "font-src 'self'",
        "connect-src 'self' https://api.vision-guide.com",
        "frame-ancestors 'none'",
        "base-uri 'self'",
        "form-action 'self'"
    ].join("; ")
};

// For development, use meta tag
<meta 
    http-equiv="Content-Security-Policy" 
    content="default-src 'self'; script-src 'self' 'unsafe-inline';" 
/>
```

### 3. Secure Token Storage

```typescript
// ❌ NEVER store sensitive data in localStorage
localStorage.setItem('jwt_token', token);  // Vulnerable to XSS

// ✅ Use httpOnly cookies (set by backend)
// Backend response:
response.set_cookie(
    key="access_token",
    value=token,
    httponly=True,  # Not accessible via JavaScript
    secure=True,    # HTTPS only
    samesite="strict",  # CSRF protection
    max_age=1800    # 30 minutes
)

// ✅ Or use sessionStorage for temporary storage
sessionStorage.setItem('temp_token', token);  // Cleared on tab close

// ✅ For client-side storage, use encrypted storage
import CryptoJS from 'crypto-js';

class SecureStorage {
    private static encrypt(data: string): string {
        const key = process.env.REACT_APP_ENCRYPTION_KEY!;
        return CryptoJS.AES.encrypt(data, key).toString();
    }
    
    private static decrypt(data: string): string {
        const key = process.env.REACT_APP_ENCRYPTION_KEY!;
        const bytes = CryptoJS.AES.decrypt(data, key);
        return bytes.toString(CryptoJS.enc.Utf8);
    }
    
    static setItem(key: string, value: any): void {
        const encrypted = this.encrypt(JSON.stringify(value));
        sessionStorage.setItem(key, encrypted);
    }
    
    static getItem(key: string): any {
        const encrypted = sessionStorage.getItem(key);
        if (!encrypted) return null;
        return JSON.parse(this.decrypt(encrypted));
    }
}
```

### 4. Form Security

```typescript
import { useState } from 'react';
import axios from 'axios';

// CSRF Token handling
const useCSRFToken = () => {
    const [csrfToken, setCSRFToken] = useState<string>('');
    
    useEffect(() => {
        // Get CSRF token from backend
        axios.get('/api/csrf-token').then(response => {
            setCSRFToken(response.data.token);
        });
    }, []);
    
    return csrfToken;
};

// Secure form submission
const SecureForm: React.FC = () => {
    const csrfToken = useCSRFToken();
    const [formData, setFormData] = useState({ email: '', password: '' });
    
    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        
        // Client-side validation
        if (!formData.email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
            alert('Invalid email format');
            return;
        }
        
        if (formData.password.length < 8) {
            alert('Password must be at least 8 characters');
            return;
        }
        
        try {
            const response = await axios.post('/api/login', {
                ...formData,
                csrf_token: csrfToken
            }, {
                headers: {
                    'X-CSRF-Token': csrfToken
                },
                withCredentials: true  // Include cookies
            });
            
            // Handle success
        } catch (error) {
            // Handle error without exposing details
            console.error('Login failed');
        }
    };
    
    return (
        <form onSubmit={handleSubmit}>
            <input
                type="email"
                name="email"
                value={formData.email}
                onChange={(e) => setFormData({...formData, email: e.target.value})}
                autoComplete="email"
                required
            />
            <input
                type="password"
                name="password"
                value={formData.password}
                onChange={(e) => setFormData({...formData, password: e.target.value})}
                autoComplete="current-password"
                required
            />
            <button type="submit">Login</button>
        </form>
    );
};
```

### 5. API Request Security

```typescript
import axios from 'axios';

// Configure axios defaults
const apiClient = axios.create({
    baseURL: process.env.REACT_APP_API_URL,
    timeout: 10000,
    withCredentials: true,
});

// Request interceptor for auth
apiClient.interceptors.request.use(
    (config) => {
        // Add auth token if available
        const token = SecureStorage.getItem('auth_token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        
        // Add request ID for tracking
        config.headers['X-Request-ID'] = crypto.randomUUID();
        
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

// Response interceptor for error handling
apiClient.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response?.status === 401) {
            // Token expired or invalid
            SecureStorage.removeItem('auth_token');
            window.location.href = '/login';
        }
        
        // Don't expose internal error details
        const genericError = {
            message: 'An error occurred',
            status: error.response?.status
        };
        
        return Promise.reject(genericError);
    }
);
```

## Attack Surface Reduction

### 1. Minimize Exposed Endpoints

```python
# Only expose necessary endpoints
# Use versioning to maintain compatibility
from fastapi import APIRouter

# Public endpoints - minimal exposure
public_router = APIRouter(prefix="/api/v1/public")

@public_router.get("/health")
async def health_check():
    return {"status": "healthy"}

@public_router.post("/auth/login")
async def login(credentials: LoginCredentials):
    pass

# Protected endpoints - require authentication
protected_router = APIRouter(
    prefix="/api/v1",
    dependencies=[Depends(verify_token)]
)

@protected_router.get("/users/profile")
async def get_profile(current_user: User = Depends(get_current_user)):
    pass

# Admin endpoints - strict access control
admin_router = APIRouter(
    prefix="/api/v1/admin",
    dependencies=[Depends(verify_admin_role)]
)

@admin_router.get("/users")
async def list_all_users():
    pass
```

### 2. Dependency Security

```json
// package.json - use exact versions and audit regularly
{
  "dependencies": {
    "react": "18.2.0",
    "axios": "1.6.2",
    "dompurify": "3.0.6"
  },
  "scripts": {
    "audit": "npm audit --production",
    "audit:fix": "npm audit fix --force"
  }
}
```

```python
# pyproject.toml - pin versions
[tool.poetry.dependencies]
python = "^3.11"
fastapi = "0.104.1"
pydantic = "2.5.0"
sqlalchemy = "2.0.23"
jose = {extras = ["cryptography"], version = "3.3.0"}

# Run security checks
# poetry run safety check
# poetry run bandit -r src/
```

### 3. Environment Configuration

```python
# Secure environment variable handling
from pydantic import BaseSettings, SecretStr, validator
from typing import Optional

class Settings(BaseSettings):
    # Database
    database_url: SecretStr
    
    # Security
    secret_key: SecretStr
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    # API Keys
    stripe_api_key: Optional[SecretStr] = None
    sendgrid_api_key: Optional[SecretStr] = None
    
    # Environment
    environment: str = "production"
    debug: bool = False
    
    @validator('secret_key')
    def validate_secret_key(cls, v):
        if len(v.get_secret_value()) < 32:
            raise ValueError('Secret key must be at least 32 characters')
        return v
    
    @validator('debug')
    def validate_debug(cls, v, values):
        if v and values.get('environment') == 'production':
            raise ValueError('Debug mode cannot be enabled in production')
        return v
    
    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()
```

## Security Monitoring & Logging

### 1. Security Event Logging

```python
import logging
from datetime import datetime
from typing import Optional

class SecurityLogger:
    def __init__(self):
        self.logger = logging.getLogger("security")
        handler = logging.FileHandler("security.log")
        formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        handler.setFormatter(formatter)
        self.logger.addHandler(handler)
        self.logger.setLevel(logging.INFO)
    
    def log_auth_attempt(self, username: str, success: bool, ip: str):
        self.logger.info(f"AUTH_ATTEMPT: user={username}, success={success}, ip={ip}")
    
    def log_access_denied(self, user_id: str, resource: str, ip: str):
        self.logger.warning(f"ACCESS_DENIED: user={user_id}, resource={resource}, ip={ip}")
    
    def log_suspicious_activity(self, description: str, ip: str, user_id: Optional[str] = None):
        self.logger.warning(f"SUSPICIOUS: {description}, user={user_id}, ip={ip}")

security_logger = SecurityLogger()

# Usage in endpoints
@router.post("/auth/login")
async def login(request: Request, credentials: LoginCredentials):
    ip = request.client.host
    try:
        user = authenticate_user(credentials)
        security_logger.log_auth_attempt(credentials.username, True, ip)
        return {"access_token": create_access_token(user)}
    except AuthenticationError:
        security_logger.log_auth_attempt(credentials.username, False, ip)
        raise HTTPException(status_code=401, detail="Invalid credentials")
```

### 2. Request Monitoring

```python
from fastapi import Request
import time
import uuid

@app.middleware("http")
async def security_middleware(request: Request, call_next):
    # Generate request ID
    request_id = str(uuid.uuid4())
    request.state.request_id = request_id
    
    # Track request timing
    start_time = time.time()
    
    # Log request
    logger.info(f"REQUEST_START: {request.method} {request.url.path} id={request_id}")
    
    # Process request
    response = await call_next(request)
    
    # Calculate duration
    duration = time.time() - start_time
    
    # Add security headers
    response.headers["X-Request-ID"] = request_id
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
    
    # Log response
    logger.info(f"REQUEST_END: {request.method} {request.url.path} status={response.status_code} duration={duration:.3f}s id={request_id}")
    
    return response
```

## Security Checklist

### Backend Security Checklist
- [ ] All endpoints require authentication (except public ones)
- [ ] Input validation using Pydantic models
- [ ] SQL injection prevention (parameterized queries)
- [ ] Rate limiting on sensitive endpoints
- [ ] CORS properly configured
- [ ] Secrets stored in environment variables
- [ ] Error messages don't leak sensitive information
- [ ] Security headers implemented
- [ ] Dependencies regularly updated and audited
- [ ] Logging for security events

### Frontend Security Checklist
- [ ] No sensitive data in localStorage
- [ ] XSS prevention (React escaping, DOMPurify)
- [ ] CSP headers configured
- [ ] HTTPS enforced
- [ ] Secure cookie settings
- [ ] CSRF protection implemented
- [ ] Input validation before submission
- [ ] API errors handled without exposing details
- [ ] Dependencies regularly updated
- [ ] No hardcoded secrets or API keys

### Deployment Security Checklist
- [ ] HTTPS/TLS configured
- [ ] Security headers in place
- [ ] Environment variables secured
- [ ] Database connections encrypted
- [ ] Firewall rules configured
- [ ] Intrusion detection active
- [ ] Regular security scans
- [ ] Backup and recovery plan
- [ ] Incident response plan
- [ ] Security monitoring and alerting

## References

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [FastAPI Security](https://fastapi.tiangolo.com/tutorial/security/)
- [React Security Best Practices](https://react.dev/learn/security)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
