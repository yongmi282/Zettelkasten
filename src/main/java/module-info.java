open module de.danielluedecke.Zettelkasten {

    requires java.desktop;
    requires java.logging;
    requires org.apache.commons.lang3;

    requires appframework;
    requires swing.layout;
    requires jdom2;
    requires javabib;
    requires opencsv;

    exports de.danielluedecke.zettelkasten to appframework;
}
