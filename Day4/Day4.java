import java.math.BigInteger;
import java.security.MessageDigest;

class Day4 {
	static final String PREFIX = "yzbqklnj";

	public static void main(String[] args) throws Exception {
		boolean lookFor5 = true;

		for (int i = 1;; i++) {
			if (lookFor5 && test(i, "00000")) {
				System.out.println("First number with 5 zeroes: " + i);
				lookFor5 = false;
			} 
			if (test(i, "000000")) {
				System.out.println("First number with 6 zeroes: " + i);	
				return;
			}
		}
	}

	static boolean test(int i, String tgtPrefix) throws Exception {
		String input = PREFIX + i;
		MessageDigest digest = MessageDigest.getInstance("MD5");
		String hash = toHex(digest.digest(input.getBytes()));
		return hash.startsWith(tgtPrefix);
	}

	static String toHex(byte[] bytes) {
	    BigInteger bigInt = new BigInteger(1, bytes);
	    return String.format("%0" + (bytes.length << 1) + "X", bigInt);
	}
}