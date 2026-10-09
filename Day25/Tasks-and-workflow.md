# FitTrack: tasks and workflow

One developer builds FitTrack in four weekly milestones, using feature branches and pull requests on GitHub.

## Team and roles

This is an individual project, so one developer holds every role.

| Role | Who | Responsibilities |
| --- | --- | --- |
| Developer and project owner | Maram | Requirements, wireframes, UI, state management, Firebase setup, testing, documentation, Git repository |
| Reviewer | Company supervisor | Reviews the weekly progress and the final demo |

The team-of-three items in the brief (task assignment, code review, standup) are adapted below for one person.

## Task breakdown

The work is 20 tasks, about 79 hours, in four weekly milestones. Hours are estimates.

| # | Task | Week | Estimate (hours) | Branch |
| --- | --- | --- | --- | --- |
| 1 | Create the Flutter project, Git repository and folder structure | 1 | 2 | `main` |
| 2 | Create the Firebase project and run `flutterfire configure` | 1 | 2 | `feature/firebase-setup` |
| 3 | Theme, router and bottom navigation shell | 1 | 4 | `feature/app-shell` |
| 4 | Auth repository and providers | 1 | 4 | `feature/auth` |
| 5 | Login, Register and Forgot password screens | 1 | 6 | `feature/auth` |
| 6 | Firestore security rules | 1 | 1 | `feature/firebase-setup` |
| 7 | Workout model and repository | 2 | 3 | `feature/workouts` |
| 8 | Workouts list screen | 2 | 4 | `feature/workouts` |
| 9 | Add / edit workout form with validation | 2 | 5 | `feature/workouts` |
| 10 | Delete workout with confirmation | 2 | 1 | `feature/workouts` |
| 11 | Home dashboard | 2 | 5 | `feature/home` |
| 12 | Water tracker | 3 | 5 | `feature/water` |
| 13 | BMI calculator and weight entries | 3 | 4 | `feature/bmi` |
| 14 | Goals screen | 3 | 4 | `feature/goals` |
| 15 | Progress charts | 3 | 8 | `feature/progress` |
| 16 | Profile screen and log out | 4 | 3 | `feature/profile` |
| 17 | Loading, empty and error states on every screen | 4 | 4 | `feature/polish` |
| 18 | Unit tests for BMI and models; widget test for Login | 4 | 5 | `feature/tests` |
| 19 | Manual testing on a real device and bug fixes | 4 | 6 | `fix/...` |
| 20 | README, screenshots and demo | 4 | 3 | `docs/readme` |

**Milestones**

- **End of week 1:** a user can register, log in and see the empty app shell.
- **End of week 2:** workouts can be added, edited and deleted, and Home shows the weekly total.
- **End of week 3:** water, BMI, goals and charts all work.
- **End of week 4:** tested, documented and ready to demo.

## Git workflow

`main` always holds a version that runs; all work happens on short-lived branches and reaches `main` through a pull request.

1. Update `main`: `git checkout main` then `git pull`.
2. Create a branch for the task: `git checkout -b feature/workouts`.
3. Commit small, working steps with a clear message.
4. Push the branch: `git push -u origin feature/workouts`.
5. Open a pull request into `main` on GitHub and go through the review checklist below.
6. Merge with "Squash and merge", then delete the branch.

**Branch names:** `feature/<name>` for new work, `fix/<name>` for bugs, `docs/<name>` for documentation.

**Commit messages:** start with the type, then say what changed.

```
feat: add login screen
fix: prevent saving a workout with zero duration
docs: add setup steps to README
refactor: move Firestore paths to constants
test: add BMI calculation tests
```

## Code review

With one developer, every pull request gets a self-review against this checklist before it is merged. The supervisor is added as a reviewer on the pull requests that close a weekly milestone.

- [ ] `flutter analyze` reports no issues
- [ ] `dart format .` has been run
- [ ] `flutter test` passes
- [ ] The feature was tested by hand on a device or emulator
- [ ] Loading, empty and error states are handled
- [ ] No Firebase imports outside a `data` folder
- [ ] No leftover `print` calls or commented-out code
- [ ] The pull request description says what changed and includes a screenshot for UI work
- [ ] The diff was read line by line on GitHub before merging

## Daily check-in

The daily standup becomes a five-minute written note at the start of each working day, saved in `docs/daily-log.md` in the repository and shared with the supervisor when asked.

1. What did I finish yesterday?
2. What will I finish today?
3. What is blocking me?

At the end of each week the task table is updated and the milestone is demoed to the supervisor.
