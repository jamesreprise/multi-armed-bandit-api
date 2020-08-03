# Multi-Armed Bandit API Challenge

## General Information
https://en.wikipedia.org/wiki/Multi-armed_bandit

## Game Information
A game has 100 turns, 100 bandits. Each bandit (or lever) has a different probability of granting a reward (between 0 and 100 per cent). The reward for each bandit (or lever) is static, and chosen at game creation time.

Tip: try looking up "multi-armed bandit strategies". See how high a score you can get!

## Challenges
- Get registered.
- Start a game.
- Finish a game.
- Calculate your "regret" (see the wikipedia page.)
- Try implementing epsilon-first or epsilon-greedy.
- Try playing multiple games at once!

## API Information
Register as a user:

{HOST}/api/register 
```json
{"auth": "<AUTH>", "nick": "<YOUR_NICKNAME>"}
```
This returns your API key. Keep it safe, you only get it once!

--------------

Create a new game:

{HOST}/api/game/new 
```json
{"reg": "<YOUR_API_KEY>"}
```
This creates a new game and returns the game ID and game information.

--------------

Get game information:

{HOST}/api/game/ `<GAME_ID>`
```json
{"reg": "<YOUR_API_KEY>"}
```
This returns the game information.

--------------

Pull a lever:

{HOST}/api/game/ `<GAME_ID>`/`<LEVER_ID>`
```json
{"reg": "<YOUR_API_KEY>"}
```
This pulls a lever, returns the reward and the game information.
