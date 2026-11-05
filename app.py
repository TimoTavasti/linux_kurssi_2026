from flask import Flask, render_template
import mariadb

app = Flask(__name__)

@app.route("/")
def home():

    conn = mariadb.connect(
        user="flaskuser",
        password="salasana123",
        host="localhost",
        database="visitorcounter"
    )

    cur = conn.cursor()

    cur.execute("SELECT visits FROM counter")
    visits = cur.fetchone()[0]

    visits += 1

    cur.execute(
        "UPDATE counter SET visits = ?",
        (visits,)
    )

    conn.commit()

    cur.close()
    conn.close()

    return render_template(
        "index.html",
        visits=visits
    )

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
