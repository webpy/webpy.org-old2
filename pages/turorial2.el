# Φροντιστήριο για το web.py 0.2

## Ξεκινώντας

Αν γνωρίζετε Python και θέλετε να φτιάξετε ένα σάιτ, το web.py παρέχει τον κώδικα ώστε να το φτιάξετε εύκολα.

Για να παρακολουθήσετε ολόκληρο το φροντιστήριο, θα πρέπει να έχετε εγκατεστημένα τα εξής: Python, web.py, flup, psycopg2 και Postgres (ή κάποια αντίστοιχη βάση δεδομένων και τον οδηγό της). Για οδηγίες, κοιτάχτε [εδώ](http://webpy.org/install).

Αν έχετε ήδη ένα υπάρχον πρότζεκτ γραμμένο σε web.py, ρίχτε μια ματιά στην σελίδα [αναβάθμισης](http://webpy.infogami.com/upgrade_to_point2) για πληροφορίες μεταφοράς.

Ας ξεκινήσουμε.

## Διαχείριση των URL

Το πιο σημαντικό κομμάτι κάθε σάιτ είναι η δομή των URL του. Τα URL σας δεν είναι μόνο αυτά που βλέπουν οι επισκέπτες σας, και τα οποία στέλνουν με μέηλ στους φίλους τους, αλλά επίσης παρέχουν ένα νοητό μοντέλο του πως δουλεύει το σάιτ. Σε δημοφιλή σάιτ όπως το [del.icio.us](http://del.icio.us/|del.icio.us), τα URL είναι κομμάτι του user interface. Το web.py σας βοηθά να φτιάχνετε καλά URL.

Για να ξεκινήσετε την εφαρμογή σας, ανοίξτε ένα νέο αρχείο κειμένου (ας το πούμε `code.py`) και γράψτε:

    import web.py

Έτσι αποκτούμε πρόσβαση στον κώδικα του web.py.

Τώρα, χρειαζόμαστε να πούμε στο web.py την δομή των URL μας. Ας βάλουμε κάτι απλό για αρχή:

    urls = (
      '/', 'index',
      '',  'index'    )

Το πρώτο μέρος είναι μια [κανονική έκφραση](http://osteele.com/tools/rework/) που ταιριάζει ένα URL, όπως τα `/`, `/help/faq`, `/item/(\d+)`, κτλ (σημ: το `\d+` ταιριάζει σε μια ακολουθία αριθμών). Οι παρενθέσεις σώζουν το κείμενο που ταιριάχτηκε με τα δεδομένα για περαιτέρω χρήση. Το δεύτερο μέρος είναι το όνομα της κλάσης στην οποία στέλνουμε το αίτημα, όπως: `index`, `view`, `welcomes.hello` (η οποία παίρνει την κλάση `hello` από το `welcomes`) ή `get_\1`. Το `\1` αντικαθίσταται από το πρώτο μέρος της κανονικής έκφρασης που σώθηκε νωρίτερα· τα υπόλοιπα κομμάτια της κανονικής έκφρασης που σώθηκαν περνάνε στην συνάρτησή σας.

Η γραμμή μας λέει πως θέλουμε το URL `/` (σημ: η πρώτη σελίδα) να το χειρίζεται η κλάση με όνομα `index`.

