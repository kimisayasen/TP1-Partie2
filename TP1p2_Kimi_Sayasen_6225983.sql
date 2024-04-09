-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom: Kimi Sayasen                        Votre DA: 6225983
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
DESC OUTILS_EMPRUNT;
DESC OUTILS_OUTIL;
DESC OUTILS_USAGER;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
SELECT CONCAT(PRENOM, ' ', NOM_FAMILLE) AS NOM_COMPLET 
FROM OUTILS_USAGER;

-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2
SELECT DISTINCT VILLE 
FROM OUTILS_USAGER 
ORDER BY VILLE;

-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
SELECT * 
FROM OUTILS_OUTIL
ORDER BY NOM, CODE_OUTIL;

-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
SELECT NUM_EMPRUNT 
FROM OUTILS_EMPRUNT 
WHERE DATE_RETOUR IS NULL;

-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3
SELECT NUM_EMPRUNT 
FROM OUTILS_EMPRUNT 
WHERE DATE_EMPRUNT < TO_DATE('01/01/2014', 'DD/MM/YYYY');

-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
SELECT NOM, CODE_OUTIL 
FROM OUTILS_OUTIL 
WHERE UPPER(CARACTERISTIQUES);

-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2
SELECT NOM, CODE_OUTIL
FROM OUTILS_OUTIL
WHERE FABRICANT = 'Stanley';

-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2
SELECT NOM, FABRICANT
FROM OUTILS_OUTIL
WHERE ANNEE BETWEEN 2006 AND 2008;

-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3
SELECT CODE_OUTIL, NOM
FROM OUTILS_OUTIL
WHERE CARACTERISTIQUES NOT LIKE '%20 volt%';

-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
SELECT COUNT(*)
FROM OUTILS_OUTIL
WHERE FABRICANT != 'Makita';

-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
SELECT CONCAT(Usager.NOM_FAMILLE, ' ', Usager.PRENOM) AS NOM_COMPLET_USAGER,
Emprunt.NUM_EMPRUNT,
Emprunt.DATE_RETOUR - Emprunt.DATE_EMPRUNT AS DUREE_EMPRUNT,
Outil.PRIX
FROM OUTILS_EMPRUNT Emprunt
JOIN OUTILS_USAGER Usager ON Emprunt.NUM_USAGER = Usager.NUM_USAGER
JOIN OUTILS_OUTIL Outil ON Emprunt.CODE_OUTIL = Outil.CODE_OUTIL
WHERE Usager.VILLE IN ('Vancouver', 'Regina');

-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4
SELECT Outil.NOM, Emprunt.CODE_OUTIL
FROM OUTILS_EMPRUNT Emprunt
JOIN OUTILS_OUTIL Outil
ON Emprunt.CODE_OUTIL = Outil.CODE_OUTIL
WHERE Emprunt.DATE_RETOUR IS NULL;

-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3
SELECT NOM_FAMILLE || ' ' || PRENOM AS NOM_COMPLET,COURRIEL
FROM OUTILS_USAGER
WHERE NUM_USAGER NOT IN (SELECT DISTINCT NUM_USAGER 
FROM OUTILS_EMPRUNT);

-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4
FROM OUTILS_OUTIL Outil
LEFT OUTER JOIN OUTILS_EMPRUNT Emprunt
ON Outil.CODE_OUTIL = Emprunt.CODE_OUTIL
WHERE Emprunt.CODE_OUTIL IS NULL;

-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4
SELECT Outil.NOM,
NVL(Outil.PRIX, AVG(Outil2.PRIX) OVER ()) AS PRIX
FROM OUTILS_OUTIL Outil
JOIN (SELECT CODE_OUTIL,
      PRIX
      FROM OUTILS_OUTIL
      WHERE FABRICANT = 'Makita')Moyenne 

ON Outil.CODE_OUTIL = Moyenne.CODE_OUTIL
JOIN (SELECT PRIX
      FROM OUTILS_OUTIL
      WHERE PRIX IS NOT NULL
      ) Outil2 
ON 1=1;

-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4
SELECT Usager.NOM_FAMILLE AS NOM,
Usager.PRENOM,
Usager.ADRESSE,
Outil.NOM AS NOM_OUTIL,
Outil.CODE_OUTIL

FROM OUTILS_USAGER Usager
JOIN OUTILS_EMPRUNT Emprunt ON Usager.NUM_USAGER = Emprunt.NUM_USAGER
JOIN OUTILS_OUTIL Outil ON Emprunt.CODE_OUTIL = Outil.CODE_OUTIL
WHERE Emprunt.DATE_EMPRUNT > TO_DATE('2014-01-01', 'YYYY-MM-DD')
ORDER BY Usager.NOM_FAMILLE;

-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4
SELECT Outil.NOM,
Outil.PRIX
FROM OUTILS_OUTIL Outil
JOIN OUTILS_EMPRUNT Emprunt ON Outil.CODE_OUTIL = Emprunt.CODE_OUTIL
GROUP BY Outil.NOM, Outil.PRIX
HAVING COUNT(Emprunt.CODE_OUTIL) > 1;

-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6

--  Une jointure
SELECT Usager.NOM_FAMILLE,
Usager.ADRESSE,
Usager.VILLE
FROM OUTILS_USAGER Usager
JOIN OUTILS_EMPRUNT Emprunt ON Usager.NUM_USAGER = Emprunt.NUM_USAGER;

--  IN
SELECT NOM_FAMILLE,
ADRESSE,
VILLE
FROM OUTILS_USAGER
WHERE NUM_USAGER IN (SELECT NUM_USAGER FROM OUTILS_EMPRUNT);

--  EXISTS
SELECT NOM_FAMILLE,
ADRESSE,
VILLE
FROM OUTILS_USAGER Usager
WHERE EXISTS (
        SELECT 1
        FROM OUTILS_EMPRUNT Emprunt
        WHERE Usager.NUM_USAGER = Emprunt.NUM_USAGER
    );

-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3
SELECT FABRICANT AS MARQUE,
AVG(PRIX) AS MOYENNE_PRIX
FROM OUTILS_OUTIL
GROUP BY FABRICANT;

-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4
SELECT VILLE, SUM(PRIX) AS SOMME_PRIX
FROM OUTILS_USAGER Usager
JOIN OUTILS_EMPRUNT Emprunt 
ON Usager.NUM_USAGER = Emprunt.NUM_USAGER
JOIN OUTILS_OUTIL Outil 
ON Emprunt.CODE_OUTIL = Outil.CODE_OUTIL
GROUP BY VILLE
ORDER BY SOMME_PRIX DESC;

-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2
x
-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, ANNEE)
VALUES ('NOUVEAU_CODE', 'Nouveau Nom', '2010');

-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2
DELETE FROM OUTILS_OUTIL
WHERE CODE_OUTIL IN ('NOUVEAU_CODE_1', 'NOUVEAU_CODE_2');

-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2
UPDATE OUTILS_USAGER
SET NOM_FAMILLE = UPPER(NOM_FAMILLE);
