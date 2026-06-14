import argparse
import re
import smtplib
import sys
from email.message import EmailMessage


def parse_bool(value):
    if value is None:
        return False
    normalized = value.strip().lower()
    if normalized in ("1", "true", "yes", "on"):
        return True
    if normalized in ("0", "false", "no", "off", ""):
        return False
    raise argparse.ArgumentTypeError(f"Invalid boolean value: {value}")


def split_addresses(value):
    if not value:
        return []
    parts = re.split(r"[;,\n]+", value)
    return [addr.strip() for addr in parts if addr.strip()]


def main():
    parser = argparse.ArgumentParser(description="Send an SMTP email from GitHub Actions.")
    parser.add_argument("--smtp-server", required=True)
    parser.add_argument("--smtp-port", type=int, default=587)
    parser.add_argument("--smtp-username", default="")
    parser.add_argument("--smtp-password", default="")
    parser.add_argument("--from", dest="from_address", required=True)
    parser.add_argument("--to", required=True)
    parser.add_argument("--subject", default="")
    parser.add_argument("--body", default="")
    parser.add_argument("--body-type", choices=("plain", "html"), default="plain")
    parser.add_argument("--use-tls", type=parse_bool, default=True)
    parser.add_argument("--use-ssl", type=parse_bool, default=False)

    args = parser.parse_args()
    recipients = split_addresses(args.to)
    if not recipients:
        parser.error("The --to input must include at least one email address.")

    message = EmailMessage()
    message["From"] = args.from_address
    message["To"] = ", ".join(recipients)
    message["Subject"] = args.subject

    if args.body_type == "html":
        message.add_alternative(args.body, subtype="html")
    else:
        message.set_content(args.body)

    if args.use_ssl:
        smtp_client = smtplib.SMTP_SSL(args.smtp_server, args.smtp_port, timeout=60)
    else:
        smtp_client = smtplib.SMTP(args.smtp_server, args.smtp_port, timeout=60)
        if args.use_tls:
            smtp_client.starttls()

    try:
        if args.smtp_username:
            smtp_client.login(args.smtp_username, args.smtp_password)
        smtp_client.send_message(message)
    finally:
        smtp_client.quit()

    print(f"SMTP email sent to: {', '.join(recipients)}")


if __name__ == "__main__":
    main()
