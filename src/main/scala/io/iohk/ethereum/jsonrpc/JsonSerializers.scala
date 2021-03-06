package io.iohk.ethereum.jsonrpc

import akka.util.ByteString
import io.iohk.ethereum.domain.Address
import org.json4s.JsonAST.{JNull, JString}
import org.json4s.CustomSerializer
import org.spongycastle.util.encoders.Hex

object JsonSerializers {

  object UnformattedDataJsonSerializer extends CustomSerializer[ByteString](_ =>
    (
      { PartialFunction.empty },
      { case bs: ByteString => JString(s"0x${Hex.toHexString(bs.toArray)}") }
    )
  )

  object QuantitiesSerializer extends CustomSerializer[BigInt](_ =>
    (
      {PartialFunction.empty},
      {
        case n: BigInt =>
          if(n == 0)
            JString("0x0")
          else
            JString(s"0x${Hex.toHexString(n.toByteArray).dropWhile(_ == '0')}")
      }
    )
  )

  object OptionNoneToJNullSerializer extends CustomSerializer[Option[_]](formats =>
    (
      {PartialFunction.empty},
      { case None => JNull }
    )
  )

  object AddressJsonSerializer extends CustomSerializer[Address](_ =>
    (
      { PartialFunction.empty },
      { case addr: Address => JString(s"0x${Hex.toHexString(addr.bytes.toArray)}")  }
    )
  )

}
