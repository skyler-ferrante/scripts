#!/bin/python3

"""log_all_discord_messages.py:
    Simple python discord client to log all discord messages
    Especially useful for watching discord C2 traffic
"""

__author__ = "Skyler Ferrante"

import discord
import datetime
import sys

intents = discord.Intents.default()
intents.members = True
client = discord.Client(intents=intents)

# Ask for discord token (from stderr, that way we can still redirect stdout)
TOKEN = input("Token: ").strip()
print("Joining with token:",TOKEN, file=sys.stderr)

class ReplyClient(discord.Client):
        async def on_message(self, message):
            print(message.content,message.author, datetime.datetime.now())

client = ReplyClient()
client.run(TOKEN)
