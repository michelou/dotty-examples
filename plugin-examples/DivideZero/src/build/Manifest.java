class Manifest {

    public static void main(String[] args) {
        java.util.Properties p = System.getProperties();
        String version = p.getProperty("java.version");
        String vendor = p.getProperty("java.vendor");
        System.out.println("Created-By: "+version+" ("+vendor+")");
    }

}
