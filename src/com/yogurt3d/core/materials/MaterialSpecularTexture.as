/*
 * MaterialSpecularBitmap.as
 * This file is part of Yogurt3D Flash Rendering Engine 
 *
 * Copyright (C) 2011 - Yogurt3D Corp.
 *
 * Yogurt3D Flash Rendering Engine is free software; you can redistribute it and/or
 * modify it under the terms of the YOGURT3D CLICK-THROUGH AGREEMENT
 * License.
 * 
 * Yogurt3D Flash Rendering Engine is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * 
 * You should have received a copy of the YOGURT3D CLICK-THROUGH AGREEMENT
 * License along with this library. If not, see <http://www.yogurt3d.com/yogurt3d/downloads/yogurt3d-click-through-agreement.html>. 
 */
 
 
package com.yogurt3d.core.materials
{
	
	import com.yogurt3d.core.materials.base.Material;
	import com.yogurt3d.core.materials.shaders.ShaderAmbient;
	import com.yogurt3d.core.materials.shaders.ShaderDiffuse;
	import com.yogurt3d.core.materials.shaders.ShaderShadow;
	import com.yogurt3d.core.materials.shaders.ShaderSpecular;
	import com.yogurt3d.core.materials.shaders.ShaderTexture;
	import com.yogurt3d.core.materials.shaders.base.Shader;
	import com.yogurt3d.core.texture.TextureMap;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.events.Event;
	
	/**
	 * 
	 * 
 	 * @author Yogurt3D Engine Core Team
 	 * @company Yogurt3D Corp.
 	 **/
	public class MaterialSpecularTexture extends Material
	{
		private var m_lightShader:ShaderSpecular;
		private var m_ambientShader:ShaderAmbient;
		private var m_decalShader:ShaderTexture;
		private var m_normalMap:TextureMap;
		private var m_specularMap:TextureMap;
		private var m_alphaTexture:Boolean = false;
		
		public function MaterialSpecularTexture( _texture:TextureMap = null, _opacity:Number = 1, _initInternals:Boolean=true)
		{
			super(_initInternals);
			
			m_decalShader = new ShaderTexture(_texture, 0);
			m_decalShader.params.blendEnabled = true;
			m_decalShader.params.blendSource = Context3DBlendFactor.DESTINATION_COLOR;
			m_decalShader.params.blendDestination = Context3DBlendFactor.ZERO;
			m_decalShader.params.depthFunction = Context3DCompareMode.EQUAL;
			
			shaders = Vector.<com.yogurt3d.core.materials.shaders.base.Shader>([
				m_ambientShader = new ShaderAmbient(_opacity),
				m_lightShader = new ShaderSpecular(_opacity),  
				m_decalShader
			]);
			
			super.opacity = _opacity;
		}
		public function get shininess():Number{
			return m_lightShader.shininess;
		}
		
		public function set shininess(_value:Number):void{
			m_lightShader.shininess = _value;
		}
		
		public function get normalMap():TextureMap
		{
			return m_normalMap;
		}
		
		public function set normalMap(value:TextureMap):void
		{
			m_normalMap = value;
			m_lightShader.normalMap = m_normalMap;
		}
		
		public function get specularMap():TextureMap
		{
			return m_specularMap;
		}
		
		public function set specularMap(value:TextureMap):void
		{
			m_specularMap = value;
			m_lightShader.specularMap = m_specularMap;
		}
		
		[Bindable(event="alphaTextureChange")]
		public function get alphaTexture():Boolean{
			return m_alphaTexture;
		}
		public function set alphaTexture(value:Boolean):void{
			
			if( m_alphaTexture != value)
			{
				m_alphaTexture = value;
				
				if( value )
				{
					m_ambientShader.alphaTexture = m_decalShader.texture as TextureMap;
				}else{
					m_ambientShader.alphaTexture = null;
				}
				
				dispatchEvent(new Event("alphaTextureChange"));
			}
		}
		
		public function get texture():TextureMap{
			return m_decalShader.texture as TextureMap;
		}
		
		public function set texture(_value:TextureMap):void{
			m_decalShader.texture = _value;
			if( m_alphaTexture )
			{
				m_ambientShader.alphaTexture = m_decalShader.texture;
			}
		}
	}
}
