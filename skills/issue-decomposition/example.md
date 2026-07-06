# Example Decomposition

**User Request**: "Build a user authentication system"

**Generated Issues**:

1. **Set up auth module structure** (Small)
   - Create directory structure
   - Add base dependencies
   - No blockers

2. **Implement user registration endpoint** (Medium)
   - POST /auth/register
   - Email/password validation
   - Blocked by: #1

3. **Implement login endpoint with JWT** (Medium)
   - POST /auth/login
   - JWT generation
   - Blocked by: #1

4. **Add password reset flow** (Medium)
   - Email token generation
   - Reset endpoint
   - Blocked by: #2

5. **Implement logout and token invalidation** (Small)
   - Token blacklist
   - Blocked by: #3

6. **Add authentication middleware** (Small)
   - Protect routes
   - Blocked by: #3

7. **Write integration tests** (Medium)
   - Test all auth endpoints
   - Blocked by: #2, #3, #4, #5
