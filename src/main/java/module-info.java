open module de.daniellluedecke.Zettelkasten {

    requires java.desktop;
    requires java.logging;
    requires appframework;
    requires swing.layout;
    requires org.apache.commons.lang3;
    requires jdom2;
    requires javabib;
    requires opencsv;

    exports de.danielluedecke.zettelkasten to appframework;
}
