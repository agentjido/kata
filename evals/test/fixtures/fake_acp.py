#!/usr/bin/env python3
"""Local ACP fixture. It does not start an agent or use a network."""
import json
import sys


def send(message):
    print(json.dumps({"jsonrpc": "2.0", **message}), flush=True)


def update(payload):
    send({"method": "session/update", "params": {"sessionId": "fake", "update": payload}})


for line in sys.stdin:
    request = json.loads(line)
    method = request.get("method")
    result = {}
    if method == "initialize":
        result = {"protocolVersion": 1, "agentCapabilities": {}, "authMethods": []}
    elif method == "session/new":
        result = {"sessionId": "fake"}
    elif method == "session/prompt":
        update({"sessionUpdate": "tool_call", "toolCallId": "one", "title": "exec_command", "status": "pending"})
        update({"sessionUpdate": "tool_call_update", "toolCallId": "one", "status": "completed"})
        update({"sessionUpdate": "agent_message_chunk", "content": {"type": "text", "text": "Final answer"}})
        update({"sessionUpdate": "usage_update", "used": 12, "size": 200000, "input_tokens": 10, "output_tokens": 2})
        result = {"stopReason": "end_turn"}
    if "id" in request:
        send({"id": request["id"], "result": result})
