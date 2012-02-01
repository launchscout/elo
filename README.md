# Elo Rating Tracking for Foosball

After getting a Foosball Table for the Gaslight Software office, it didn't take
long for talk of who was the better player and thoughts of a tournament to
begin. Getting everyone to agree on the format of a tournament is quite another
thing.

However, a bit of research turned up the [Elo Rating system][elo] as modified
by [Bonzini USA][bonzini]. This little Rails application implements this
scoring system for anyone in the office who plays. It's working so far and the
app is becoming a place where we at Gaslight are able to explore some newer
gems and techniques.

## Brief Summary of Elo

The Elo rating system is a method for calculating the relative skill levels of
players in two-player games such as chess. It is named after its creator Arpad
Elo, a Hungarian-born American physics professor.

The heart of the Elo ranking is the "Win Expectancy" expressed as a probability
that one player will beat another based on the difference between their
rankings. The Win Expectancy is defined as:

    We = 1/(10^(-D/F) + 1)

Where *D* equals the difference between the two players' rantings and *F* is
the "rating interval scale weight factor". Bonzini set the ranking interval
sizes to 500 and the weight factor to 1000.

In the Bonzini system, if you win your rating goes up by an interval constant
times the We. The loser's rating goes down by an equal amount. The Elo system
is a zero sum system. The only way to add points to the league is to add more
players.

We've slightly modified the Bonzini system to give fractional rating increases
and decreases based on the percentage of points won or lost. This has the
effect of causing the winner of the game to potentially lose ranking if the
margin by which they won doesn't exceed the Win Expectancy.

[elo]: http://en.wikipedia.org/wiki/Elo_rating_system
[bonzini]: http://www.bonziniusa.com/foosball/tournament/TournamentRankingSystem.html
