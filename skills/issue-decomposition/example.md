# Example Decomposition

**User Request**: "Build a user authentication system"

**Estimate of the whole**: bigger than 8 points, so it is an epic (`epic`) and is decomposed below. The children sum to 18, so the epic is 18 points.

**Generated Issues** (points in parentheses):

1. **Set up auth module structure** (2)
   - Create directory structure
   - Add base dependencies
   - No blockers

2. **Implement user registration endpoint** (4)
   - POST /auth/register
   - Email/password validation
   - Blocked by: #1

3. **Implement login endpoint with JWT** (4)
   - POST /auth/login
   - JWT generation
   - Blocked by: #1

4. **Add password reset flow** (4)
   - Email token generation
   - Reset endpoint
   - Blocked by: #2

5. **Implement logout and token invalidation** (1)
   - Token blacklist
   - Blocked by: #3

6. **Add authentication middleware** (1)
   - Protect routes
   - Blocked by: #3

7. **Write integration tests** (2)
   - Test all auth endpoints
   - Blocked by: #2, #3, #4, #5
