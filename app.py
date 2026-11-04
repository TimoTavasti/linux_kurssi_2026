from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def home():

    visits = 1

    return render_template(
        "index.html",
        visits=visits
    )

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
