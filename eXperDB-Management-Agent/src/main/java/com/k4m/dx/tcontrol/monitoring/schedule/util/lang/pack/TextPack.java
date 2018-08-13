
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack;

import java.io.IOException;

import com.k4m.dx.tcontrol.monitoring.schedule.util.Hexa32;



public class TextPack implements Pack {
	public String xtype;
	public int hash;
	public String text;

	public TextPack() {
	}

	public TextPack(String xtype, int hash, String text) {
		this.xtype = xtype;
		this.hash = hash;
		this.text = text;
	}

	public byte getPackType() {
		return PackEnum.TEXT;
	}

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append(xtype);
		sb.append(" ").append(Hexa32.toString32(hash));
		sb.append(" ").append(text);
		return sb.toString();
	}
/*
	public void write(DataOutputX dout) throws IOException {
		dout.writeText(xtype);
		dout.writeInt(hash);
		dout.writeText(text);
	}

	public static void writeDirect(DataOutputX dout, byte packType, String _xtype, int _hash, String _text) throws IOException {
		dout.writeByte(packType);
		dout.writeText(_xtype);
		dout.writeInt(_hash);
		dout.writeText(_text);
	}

	public Pack read(DataInputX din) throws IOException {
		this.xtype = din.readText();
		this.hash = din.readInt();
		this.text = din.readText();
		return this;
	}*/

}
